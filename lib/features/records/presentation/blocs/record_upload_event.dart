import 'package:booster/features/interviews/domain/constants/interview_constants.dart';

sealed class RecordUploadEvent {
  const RecordUploadEvent();
}

class RecordUploadStarted extends RecordUploadEvent {
  final String audioPath;
  final String transcription;
  // Datos para crear interview
  final String? projectId;
  final String? tenantId;
  final String? advisorId;
  final InterviewType? interviewType;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final int? durationSec;

  const RecordUploadStarted({
    required this.audioPath,
    required this.transcription,
    this.projectId,
    this.tenantId,
    this.advisorId,
    this.interviewType,
    this.startedAt,
    this.endedAt,
    this.durationSec,
  });
}

class RecordUploadRetried extends RecordUploadEvent {
  const RecordUploadRetried();
}

class RecordUploadReset extends RecordUploadEvent {
  const RecordUploadReset();
}
