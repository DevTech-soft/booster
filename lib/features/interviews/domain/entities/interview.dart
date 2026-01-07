import 'package:equatable/equatable.dart';
import 'package:booster/features/interviews/domain/constants/interview_constants.dart';

/// Interview Entity
/// Represents an interview (audio recording) in the domain layer
class Interview extends Equatable {
  final String id;
  final String tenantId;
  final String projectId;
  final String advisorId;
  final InterviewType interviewType;
  final String s3AudioKey;
  final String languageCode;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final int? durationSec;
  final InterviewStatus status;
  final ProcessingProvider? providerUsed;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Interview({
    required this.id,
    required this.tenantId,
    required this.projectId,
    required this.advisorId,
    required this.interviewType,
    required this.s3AudioKey,
    required this.languageCode,
    this.startedAt,
    this.endedAt,
    this.durationSec,
    required this.status,
    this.providerUsed,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        tenantId,
        projectId,
        advisorId,
        interviewType,
        s3AudioKey,
        languageCode,
        startedAt,
        endedAt,
        durationSec,
        status,
        providerUsed,
        createdAt,
        updatedAt,
      ];

  /// Returns true if the interview is still being processed
  bool get isProcessing => status.isProcessing;

  /// Returns true if the interview has completed processing
  bool get isCompleted => status.isCompleted;

  /// Returns true if the interview has failed
  bool get hasFailed => status.hasFailed;

  /// Get formatted duration (e.g., "45 min", "1h 30min")
  String get formattedDuration {
    if (durationSec == null) return 'N/A';
    final duration = Duration(seconds: durationSec!);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}min';
    }
    return '${minutes} min';
  }
}