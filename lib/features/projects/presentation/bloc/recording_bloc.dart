import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'recording_event.dart';
import 'recording_state.dart';

class RecordingBloc extends Bloc<RecordingEvent, RecordingState> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _timer;
  StreamSubscription? _amplitudeSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;
  Duration _currentDuration = Duration.zero;
  final List<double> _waveformData = [];
  String? _selectedDeviceId;
  String? _selectedDeviceName;
  DateTime? _recordingStartedAt;

  RecordingBloc() : super(const RecordingInitial()) {
    on<StartRecording>(_onStartRecording);
    on<StopRecording>(_onStopRecording);
    on<UpdateDuration>(_onUpdateDuration);
    on<UpdateAmplitude>(_onUpdateAmplitude);
    on<ResetRecording>(_onResetRecording);
    on<PlayAudio>(_onPlayAudio);
    on<PauseAudio>(_onPauseAudio);
    on<SeekForward>(_onSeekForward);
    on<SeekBackward>(_onSeekBackward);
    on<UpdatePlaybackPosition>(_onUpdatePlaybackPosition);
    on<SelectAudioDevice>(_onSelectAudioDevice);
  }

  Future<void> _onStartRecording(
    StartRecording event,
    Emitter<RecordingState> emit,
  ) async {
    try {
      // Verificar permisos
      if (await _audioRecorder.hasPermission()) {
        // Generar path para el archivo de audio
        final directory = await getTemporaryDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final path = '${directory.path}/recording_$timestamp.m4a';

        // Iniciar grabación
        await _audioRecorder.start(
          RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: path,
        );

        // Resetear datos y capturar timestamp de inicio
        _currentDuration = Duration.zero;
        _waveformData.clear();
        _recordingStartedAt = DateTime.now();

        // Emitir estado inicial de grabación
        emit(RecordingInProgress(
          duration: _currentDuration,
          waveformData: List.from(_waveformData),
        ));

        // Iniciar timer para actualizar duración
        _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
          _currentDuration = Duration(milliseconds: timer.tick * 100);
          add(UpdateDuration(_currentDuration));
        });

        // Escuchar amplitudes para crear waveform
        _amplitudeSubscription = _audioRecorder
            .onAmplitudeChanged(const Duration(milliseconds: 100))
            .listen((amplitude) {
          // Normalizar amplitud entre 0 y 1
          final normalizedAmplitude = (amplitude.current + 50) / 50;
          final clampedAmplitude = normalizedAmplitude.clamp(0.0, 1.0);
          add(UpdateAmplitude(clampedAmplitude));
        });
      } else {
        emit(const RecordingError('No hay permisos de micrófono'));
      }
    } catch (e) {
      emit(RecordingError('Error al iniciar grabación: $e'));
    }
  }

  Future<void> _onStopRecording(
    StopRecording event,
    Emitter<RecordingState> emit,
  ) async {
    try {
      // Detener timer y subscripción
      _timer?.cancel();
      _timer = null;
      await _amplitudeSubscription?.cancel();
      _amplitudeSubscription = null;

      // Detener grabación y obtener path
      final path = await _audioRecorder.stop();
      final endedAt = DateTime.now();

      // Emitir estado detenido con timestamps
      emit(RecordingStopped(
        finalDuration: _currentDuration,
        finalWaveformData: List.from(_waveformData),
        startedAt: _recordingStartedAt ?? endedAt,
        endedAt: endedAt,
        audioPath: path!,
      ));
    } catch (e) {
      emit(RecordingError('Error al detener grabación: $e'));
    }
  }

  void _onUpdateDuration(
    UpdateDuration event,
    Emitter<RecordingState> emit,
  ) {
    if (state is RecordingInProgress) {
      emit((state as RecordingInProgress).copyWith(
        duration: event.duration,
      ));
    }
  }

  void _onUpdateAmplitude(
    UpdateAmplitude event,
    Emitter<RecordingState> emit,
  ) {
    if (state is RecordingInProgress) {
      _waveformData.add(event.amplitude);
      if (_waveformData.length > 100) {
        _waveformData.removeAt(0);
      }

      emit((state as RecordingInProgress).copyWith(
        waveformData: List.from(_waveformData),
      ));
    }
  }

  void _onResetRecording(
    ResetRecording event,
    Emitter<RecordingState> emit,
  ) {
    _currentDuration = Duration.zero;
    _waveformData.clear();
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _audioPlayer.stop();
    emit(const RecordingInitial());
  }

  Future<void> _onPlayAudio(
    PlayAudio event,
    Emitter<RecordingState> emit,
  ) async {
    try {
      final currentState = state;

      if (currentState is RecordingStopped) {
        // Cancelar subscripciones previas si existen
        await _positionSubscription?.cancel();
        await _playerStateSubscription?.cancel();

        // Cargar el audio y obtener su duración real
        final audioDuration = await _audioPlayer.setFilePath(currentState.audioPath!);

        // Usar la duración real del archivo, o la duración de grabación como fallback
        final totalDuration = audioDuration ?? currentState.finalDuration;

        // Configurar subscripciones ANTES de reproducir
        // Escuchar la posición del audio
        _positionSubscription = _audioPlayer.positionStream.listen((position) {
          add(UpdatePlaybackPosition(position));
        });

        // Escuchar cuando termine la reproducción
        _playerStateSubscription = _audioPlayer.playerStateStream.listen((playerState) async {
          if (playerState.processingState == ProcessingState.completed) {
            // Pausar y hacer seek a cero ANTES de enviar el evento
            await _audioPlayer.pause();
            await _audioPlayer.seek(Duration.zero);
            add(const PauseAudio());
          }
        });

        // Emitir estado de reproducción ANTES de iniciar play para que la UI se actualice
        emit(AudioPlaying(
          totalDuration: totalDuration,
          currentPosition: Duration.zero,
          waveformData: currentState.finalWaveformData,
          audioPath: currentState.audioPath!,
        ));

        // Iniciar reproducción DESPUÉS de emitir el estado
        await _audioPlayer.play();
      } else if (currentState is AudioPaused) {
        // Determinar la posición desde donde reanudar
        var resumePosition = currentState.currentPosition;

        // Si estamos al final o muy cerca, volver al inicio
        if (resumePosition >= currentState.totalDuration ||
            (currentState.totalDuration - resumePosition).inMilliseconds < 100) {
          resumePosition = Duration.zero;
        }

        // Emitir estado de reproducción ANTES de reanudar para que la UI se actualice
        emit(AudioPlaying(
          totalDuration: currentState.totalDuration,
          currentPosition: resumePosition,
          waveformData: currentState.waveformData,
          audioPath: currentState.audioPath,
        ));

        // Reanudar reproducción desde la posición determinada DESPUÉS de emitir el estado
        await _audioPlayer.seek(resumePosition);
        await _audioPlayer.play();
      }
    } catch (e) {
      emit(RecordingError('Error al reproducir audio: $e'));
    }
  }

  Future<void> _onPauseAudio(
    PauseAudio event,
    Emitter<RecordingState> emit,
  ) async {
    try {
      await _audioPlayer.pause();

      // Obtener la posición exacta del reproductor al pausar
      final pausedPosition = _audioPlayer.position;

      final currentState = state;
      if (currentState is AudioPlaying) {
        emit(AudioPaused(
          totalDuration: currentState.totalDuration,
          currentPosition: pausedPosition,
          waveformData: currentState.waveformData,
          audioPath: currentState.audioPath,
        ));
      }
    } catch (e) {
      emit(RecordingError('Error al pausar audio: $e'));
    }
  }

  Future<void> _onSeekForward(
    SeekForward event,
    Emitter<RecordingState> emit,
  ) async {
    try {
      final currentPosition = _audioPlayer.position;
      final newPosition = currentPosition + const Duration(seconds: 5);
      final duration = _audioPlayer.duration ?? Duration.zero;

      // No avanzar más allá del final
      if (newPosition < duration) {
        await _audioPlayer.seek(newPosition);
      } else {
        await _audioPlayer.seek(duration);
      }
    } catch (e) {
      emit(RecordingError('Error al adelantar: $e'));
    }
  }

  Future<void> _onSeekBackward(
    SeekBackward event,
    Emitter<RecordingState> emit,
  ) async {
    try {
      final currentPosition = _audioPlayer.position;
      final newPosition = currentPosition - const Duration(seconds: 5);

      // No retroceder antes del inicio
      if (newPosition > Duration.zero) {
        await _audioPlayer.seek(newPosition);
      } else {
        await _audioPlayer.seek(Duration.zero);
      }
    } catch (e) {
      emit(RecordingError('Error al retroceder: $e'));
    }
  }

  void _onUpdatePlaybackPosition(
    UpdatePlaybackPosition event,
    Emitter<RecordingState> emit,
  ) {
    final currentState = state;
    if (currentState is AudioPlaying) {
      emit(currentState.copyWith(currentPosition: event.position));
    }
  }

  void _onSelectAudioDevice(
    SelectAudioDevice event,
    Emitter<RecordingState> emit,
  ) {
    _selectedDeviceId = event.deviceId;
    _selectedDeviceName = event.deviceName;
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _amplitudeSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    return super.close();
  }
}
