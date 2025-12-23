import 'package:dartz/dartz.dart';
import 'package:booster/core/error/exceptions.dart';
import 'package:booster/core/error/failures.dart';
import 'package:booster/features/projects/data/datasources/projects_remote_data_source.dart';
import 'package:booster/features/projects/domain/entities/project.dart';
import 'package:booster/features/projects/domain/repositories/projects_repository.dart';

class ProjectsRepositoryImpl implements ProjectsRepository {
  final ProjectsRemoteDataSource remoteDataSource;

  ProjectsRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<Project>>> getProjects() async {
    try {
      final projects = await remoteDataSource.getProjects();
      return Right(projects);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error al obtener proyectos: ${e.toString()}'));
    }
  }
}
