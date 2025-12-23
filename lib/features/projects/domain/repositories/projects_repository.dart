import 'package:dartz/dartz.dart';
import 'package:booster/core/error/failures.dart';
import 'package:booster/features/projects/domain/entities/project.dart';

abstract class ProjectsRepository {
  Future<Either<Failure, List<Project>>> getProjects();
}
