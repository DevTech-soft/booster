import 'package:booster/core/error/failures.dart';
import 'package:booster/core/usecases/usecase.dart';
import 'package:booster/features/interviews/domain/constants/interview_constants.dart';
import 'package:booster/features/interviews/domain/entities/interview.dart';
import 'package:booster/features/interviews/domain/repositories/interviews_repository.dart';
import 'package:dartz/dartz.dart';

/// Update Interview Use Case
/// Updates an existing interview in the system
class UpdateInterview
    implements UseCase<Either<Failure, Interview>, UpdateInterviewParams> {
  final InterviewsRepository repository;

  UpdateInterview(this.repository);

  @override
  Future<Either<Failure, Interview>> call(UpdateInterviewParams params) async {
    final data = <String, dynamic>{};

    // Only include fields that are provided
    if (params.status != null) {
      data['status'] = params.status!.value;
    }
    if (params.providerUsed != null) {
      data['provider_used'] = params.providerUsed!.value;
    }
    if (params.startedAt != null) {
      data['started_at'] = params.startedAt!.toIso8601String();
    }
    if (params.endedAt != null) {
      data['ended_at'] = params.endedAt!.toIso8601String();
    }
    if (params.durationSec != null) {
      data['duration_sec'] = params.durationSec;
    }

    return await repository.updateInterview(params.id, data);
  }
}

/// Parameters for UpdateInterview use case
class UpdateInterviewParams {
  final String id;
  final InterviewStatus? status;
  final ProcessingProvider? providerUsed;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final int? durationSec;

  UpdateInterviewParams({
    required this.id,
    this.status,
    this.providerUsed,
    this.startedAt,
    this.endedAt,
    this.durationSec,
  });
}
