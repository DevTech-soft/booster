import 'package:equatable/equatable.dart';

abstract class RecordingState extends Equatable {
  const RecordingState();

  @override
  List<Object?> get props => [];
}

class RecordingInitial extends RecordingState {
  const RecordingInitial();
}

class RecordingInProgress extends RecordingState {
  final Duration duration;
  final List<double> waveformData;

  const RecordingInProgress({
    required this.duration,
    required this.waveformData,
  });

  RecordingInProgress copyWith({
    Duration? duration,
    List<double>? waveformData,
  }) {
    return RecordingInProgress(
      duration: duration ?? this.duration,
      waveformData: waveformData ?? this.waveformData,
    );
  }

  @override
  List<Object?> get props => [duration, waveformData];
}

class RecordingStopped extends RecordingState {
  final Duration finalDuration;
  final List<double> finalWaveformData;
  final String? audioPath;

  const RecordingStopped({
    required this.finalDuration,
    required this.finalWaveformData,
    this.audioPath,
  });

  @override
  List<Object?> get props => [finalDuration, finalWaveformData, audioPath];
}

class RecordingError extends RecordingState {
  final String message;

  const RecordingError(this.message);

  @override
  List<Object?> get props => [message];
}

class AudioPlaying extends RecordingState {
  final Duration totalDuration;
  final Duration currentPosition;
  final List<double> waveformData;
  final String audioPath;

  const AudioPlaying({
    required this.totalDuration,
    required this.currentPosition,
    required this.waveformData,
    required this.audioPath,
  });

  AudioPlaying copyWith({
    Duration? totalDuration,
    Duration? currentPosition,
    List<double>? waveformData,
    String? audioPath,
  }) {
    return AudioPlaying(
      totalDuration: totalDuration ?? this.totalDuration,
      currentPosition: currentPosition ?? this.currentPosition,
      waveformData: waveformData ?? this.waveformData,
      audioPath: audioPath ?? this.audioPath,
    );
  }

  @override
  List<Object?> get props => [totalDuration, currentPosition, waveformData, audioPath];
}

class AudioPaused extends RecordingState {
  final Duration totalDuration;
  final Duration currentPosition;
  final List<double> waveformData;
  final String audioPath;

  const AudioPaused({
    required this.totalDuration,
    required this.currentPosition,
    required this.waveformData,
    required this.audioPath,
  });

  @override
  List<Object?> get props => [totalDuration, currentPosition, waveformData, audioPath];
}
