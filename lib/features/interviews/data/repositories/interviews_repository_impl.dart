import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:booster/core/error/exceptions.dart';
import 'package:booster/core/error/failures.dart';
import 'package:booster/features/interviews/data/datasources/interviews_remote_datasource.dart';
import 'package:booster/features/interviews/data/models/interview_filters_model.dart';
import 'package:booster/features/interviews/domain/entities/interview.dart';
import 'package:booster/features/interviews/domain/repositories/interviews_repository.dart';

/// Interviews Repository Implementation
/// Implements the repository interface and handles data operations
class InterviewsRepositoryImpl implements InterviewsRepository {
  final InterviewsRemoteDataSource remoteDataSource;

  InterviewsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, (List<Interview>, int)>> getInterviews(
    InterviewFiltersModel filters,
  ) async {
    try {
      final response = await remoteDataSource.getInterviews(filters);
      return Right((response.interviews, response.total));
    } on ServerException catch (e) {
      log('ServerException in getInterviews: ${e.message}');
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      log('NetworkException in getInterviews: ${e.message}');
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      log('UnauthorizedException in getInterviews: ${e.message}');
      return Left(UnauthorizedFailure(e.message));
    } on ForbiddenException catch (e) {
      log('ForbiddenException in getInterviews: ${e.message}');
      return Left(ForbiddenFailure(e.message));
    } on NotFoundException catch (e) {
      log('NotFoundException in getInterviews: ${e.message}');
      return Left(NotFoundFailure(e.message));
    } on ValidationException catch (e) {
      log('ValidationException in getInterviews: ${e.message}');
      return Left(ValidationFailure(e.message, errors: e.errors));
    } on TimeoutException catch (e) {
      log('TimeoutException in getInterviews: ${e.message}');
      return Left(TimeoutFailure(e.message));
    } catch (e) {
      log('Unexpected error in getInterviews: $e');
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Interview>> getInterviewById(String id) async {
    try {
      final interview = await remoteDataSource.getInterviewById(id);
      return Right(interview);
    } on ServerException catch (e) {
      log('ServerException in getInterviewById: ${e.message}');
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      log('NetworkException in getInterviewById: ${e.message}');
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      log('UnauthorizedException in getInterviewById: ${e.message}');
      return Left(UnauthorizedFailure(e.message));
    } on ForbiddenException catch (e) {
      log('ForbiddenException in getInterviewById: ${e.message}');
      return Left(ForbiddenFailure(e.message));
    } on NotFoundException catch (e) {
      log('NotFoundException in getInterviewById: ${e.message}');
      return Left(NotFoundFailure(e.message));
    } on ValidationException catch (e) {
      log('ValidationException in getInterviewById: ${e.message}');
      return Left(ValidationFailure(e.message, errors: e.errors));
    } on TimeoutException catch (e) {
      log('TimeoutException in getInterviewById: ${e.message}');
      return Left(TimeoutFailure(e.message));
    } catch (e) {
      log('Unexpected error in getInterviewById: $e');
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Interview>> createInterview(
    Map<String, dynamic> data,
  ) async {
    try {
      final interview = await remoteDataSource.createInterview(data);
      return Right(interview);
    } on ServerException catch (e) {
      log('ServerException in createInterview: ${e.message}');
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      log('NetworkException in createInterview: ${e.message}');
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      log('UnauthorizedException in createInterview: ${e.message}');
      return Left(UnauthorizedFailure(e.message));
    } on ForbiddenException catch (e) {
      log('ForbiddenException in createInterview: ${e.message}');
      return Left(ForbiddenFailure(e.message));
    } on NotFoundException catch (e) {
      log('NotFoundException in createInterview: ${e.message}');
      return Left(NotFoundFailure(e.message));
    } on ValidationException catch (e) {
      log('ValidationException in createInterview: ${e.message}');
      return Left(ValidationFailure(e.message, errors: e.errors));
    } on TimeoutException catch (e) {
      log('TimeoutException in createInterview: ${e.message}');
      return Left(TimeoutFailure(e.message));
    } catch (e) {
      log('Unexpected error in createInterview: $e');
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Interview>> updateInterview(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final interview = await remoteDataSource.updateInterview(id, data);
      return Right(interview);
    } on ServerException catch (e) {
      log('ServerException in updateInterview: ${e.message}');
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      log('NetworkException in updateInterview: ${e.message}');
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      log('UnauthorizedException in updateInterview: ${e.message}');
      return Left(UnauthorizedFailure(e.message));
    } on ForbiddenException catch (e) {
      log('ForbiddenException in updateInterview: ${e.message}');
      return Left(ForbiddenFailure(e.message));
    } on NotFoundException catch (e) {
      log('NotFoundException in updateInterview: ${e.message}');
      return Left(NotFoundFailure(e.message));
    } on ValidationException catch (e) {
      log('ValidationException in updateInterview: ${e.message}');
      return Left(ValidationFailure(e.message, errors: e.errors));
    } on TimeoutException catch (e) {
      log('TimeoutException in updateInterview: ${e.message}');
      return Left(TimeoutFailure(e.message));
    } catch (e) {
      log('Unexpected error in updateInterview: $e');
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteInterview(String id) async {
    try {
      await remoteDataSource.deleteInterview(id);
      return const Right(null);
    } on ServerException catch (e) {
      log('ServerException in deleteInterview: ${e.message}');
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      log('NetworkException in deleteInterview: ${e.message}');
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      log('UnauthorizedException in deleteInterview: ${e.message}');
      return Left(UnauthorizedFailure(e.message));
    } on ForbiddenException catch (e) {
      log('ForbiddenException in deleteInterview: ${e.message}');
      return Left(ForbiddenFailure(e.message));
    } on NotFoundException catch (e) {
      log('NotFoundException in deleteInterview: ${e.message}');
      return Left(NotFoundFailure(e.message));
    } on ValidationException catch (e) {
      log('ValidationException in deleteInterview: ${e.message}');
      return Left(ValidationFailure(e.message, errors: e.errors));
    } on TimeoutException catch (e) {
      log('TimeoutException in deleteInterview: ${e.message}');
      return Left(TimeoutFailure(e.message));
    } catch (e) {
      log('Unexpected error in deleteInterview: $e');
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
