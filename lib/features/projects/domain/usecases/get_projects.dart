import 'package:dartz/dartz.dart';
import 'package:booster/core/error/failures.dart';
import 'package:booster/core/usecases/usecase.dart';
import 'package:booster/features/projects/domain/entities/project.dart';
import 'package:booster/features/projects/domain/repositories/projects_repository.dart';

class GetProjects implements UseCase<Either<Failure, List<Project>>, NoParams> {
  final ProjectsRepository repository;

  GetProjects(this.repository);

  @override
  Future<Either<Failure, List<Project>>> call(NoParams params) async {
    return await repository.getProjects();
  }
}
