import 'package:booster/core/error/failures.dart';
import 'package:booster/core/usecases/usecase.dart';
import 'package:booster/features/interviews/data/models/interview_filters_model.dart';
import 'package:booster/features/interviews/domain/entities/interview.dart';
import 'package:booster/features/interviews/domain/repositories/interviews_repository.dart';
import 'package:dartz/dartz.dart';

/// Get Interviews Use Case
/// Retrieves a list of interviews with optional filters and pagination
class GetInterviews
    implements UseCase<Either<Failure, GetInterviewsResult>, GetInterviewsParams> {
  final InterviewsRepository repository;

  GetInterviews(this.repository);

  @override
  Future<Either<Failure, GetInterviewsResult>> call(
    GetInterviewsParams params,
  ) async {
    final result = await repository.getInterviews(params.filters);

    return result.fold(
      (failure) => Left(failure),
      (data) {
        final (interviews, total) = data;
        return Right(GetInterviewsResult(
          interviews: interviews,
          total: total,
        ));
      },
    );
  }
}

/// Parameters for GetInterviews use case
class GetInterviewsParams {
  final InterviewFiltersModel filters;

  GetInterviewsParams({required this.filters});
}

/// Result for GetInterviews use case
class GetInterviewsResult {
  final List<Interview> interviews;
  final int total;

  GetInterviewsResult({
    required this.interviews,
    required this.total,
  });

  /// Check if there are more items to load
  bool get hasMore => interviews.length < total;
}
