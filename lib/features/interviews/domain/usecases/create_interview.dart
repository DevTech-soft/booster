import 'package:booster/core/error/failures.dart';
import 'package:booster/core/usecases/usecase.dart';
import 'package:booster/features/interviews/domain/constants/interview_constants.dart';
import 'package:booster/features/interviews/domain/entities/interview.dart';
import 'package:booster/features/interviews/domain/repositories/interviews_repository.dart';
import 'package:dartz/dartz.dart';

/// Create Interview Use Case
/// Creates a new interview in the system
class CreateInterview
    implements UseCase<Either<Failure, Interview>, CreateInterviewParams> {
  final InterviewsRepository repository;

  CreateInterview(this.repository);

  @override
  Future<Either<Failure, Interview>> call(CreateInterviewParams params) async {
    final data = {
      'tenant_id': params.tenantId,
      'project_id': params.projectId,
      'advisor_id': params.advisorId,
      'interview_type': params.interviewType.value,
      's3_audio_key': params.s3AudioKey,
      'language_code': params.languageCode ?? InterviewConstants.defaultLanguageCode,
      'status': InterviewConstants.statusReceived,
      if (params.startedAt != null) 'started_at': params.startedAt!.toIso8601String(),
      if (params.endedAt != null) 'ended_at': params.endedAt!.toIso8601String(),
      if (params.durationSec != null) 'duration_sec': params.durationSec,
      if (params.providerUsed != null) 'provider_used': params.providerUsed,
    };

    return await repository.createInterview(data);
  }
}

/// Parameters for CreateInterview use case
class CreateInterviewParams {
  final String tenantId;
  final String projectId;
  final String advisorId;
  final InterviewType interviewType;
  final String s3AudioKey;
  final String? languageCode;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final int? durationSec;
  final String? providerUsed;

  CreateInterviewParams({
    required this.tenantId,
    required this.projectId,
    required this.advisorId,
    required this.interviewType,
    required this.s3AudioKey,
    this.languageCode,
    this.startedAt,
    this.endedAt,
    this.durationSec,
    this.providerUsed,
  });
}
