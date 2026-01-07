import 'package:booster/core/error/failures.dart';
import 'package:booster/core/usecases/usecase.dart';
import 'package:booster/features/interviews/domain/repositories/interviews_repository.dart';
import 'package:dartz/dartz.dart';

/// Delete Interview Use Case
/// Deletes an interview from the system
class DeleteInterview
    implements UseCase<Either<Failure, void>, DeleteInterviewParams> {
  final InterviewsRepository repository;

  DeleteInterview(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteInterviewParams params) async {
    return await repository.deleteInterview(params.id);
  }
}

/// Parameters for DeleteInterview use case
class DeleteInterviewParams {
  final String id;

  DeleteInterviewParams({required this.id});
}
