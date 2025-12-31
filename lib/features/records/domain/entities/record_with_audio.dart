import 'package:booster/features/projects/presentation/bloc/recording_state.dart';

abstract class RecordingWithAudio extends RecordingState {
  final String audioPath;

  const RecordingWithAudio(this.audioPath);

  @override
  List<Object?> get props => [audioPath];
}
