import 'package:booster/features/interviews/domain/constants/interview_constants.dart';

sealed class RecordUploadEvent {
  const RecordUploadEvent();
}

class RecordUploadStarted extends RecordUploadEvent {
  final String audioPath;
  final String transcription;
  // Datos obligatorios para el upload
  final String tenantId;
  final String projectId;
  final String advisorId;
  final String clientId;
  final String audioType;
  // Datos opcionales para crear interview
  final InterviewType? interviewType;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final int? durationSec;

  const RecordUploadStarted({
    required this.audioPath,
    required this.transcription,
    required this.tenantId,
    required this.projectId,
    required this.advisorId,
    required this.clientId,
    required this.audioType,
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
