import 'package:booster/core/error/failures.dart';
import 'package:booster/core/usecases/usecase.dart';
import 'package:booster/features/interviews/domain/entities/interview.dart';
import 'package:booster/features/interviews/domain/repositories/interviews_repository.dart';
import 'package:dartz/dartz.dart';

/// Get Interview By ID Use Case
/// Retrieves a specific interview by its ID
class GetInterviewById
    implements UseCase<Either<Failure, Interview>, GetInterviewByIdParams> {
  final InterviewsRepository repository;

  GetInterviewById(this.repository);

  @override
  Future<Either<Failure, Interview>> call(GetInterviewByIdParams params) async {
    return await repository.getInterviewById(params.id);
  }
}

/// Parameters for GetInterviewById use case
class GetInterviewByIdParams {
  final String id;

  GetInterviewByIdParams({required this.id});
}
