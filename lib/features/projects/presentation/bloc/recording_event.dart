import 'package:equatable/equatable.dart';

abstract class RecordingEvent extends Equatable {
  const RecordingEvent();

  @override
  List<Object?> get props => [];
}

class StartRecording extends RecordingEvent {
  const StartRecording();
}

class StopRecording extends RecordingEvent {
  const StopRecording();
}

class UpdateDuration extends RecordingEvent {
  final Duration duration;

  const UpdateDuration(this.duration);

  @override
  List<Object?> get props => [duration];
}

class UpdateAmplitude extends RecordingEvent {
  final double amplitude;

  const UpdateAmplitude(this.amplitude);

  @override
  List<Object?> get props => [amplitude];
}

class ResetRecording extends RecordingEvent {
  const ResetRecording();
}

class PlayAudio extends RecordingEvent {
  const PlayAudio();
}

class PauseAudio extends RecordingEvent {
  const PauseAudio();
}

class SeekForward extends RecordingEvent {
  const SeekForward();
}

class SeekBackward extends RecordingEvent {
  const SeekBackward();
}

class UpdatePlaybackPosition extends RecordingEvent {
  final Duration position;

  const UpdatePlaybackPosition(this.position);

  @override
  List<Object?> get props => [position];
}

class SelectAudioDevice extends RecordingEvent {
  final String deviceId;
  final String deviceName;

  const SelectAudioDevice({
    required this.deviceId,
    required this.deviceName,
  });

  @override
  List<Object?> get props => [deviceId, deviceName];
}
