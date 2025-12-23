import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      print('🔵 REPOSITORY - Llamando a remoteDataSource.signIn');
      final user = await remoteDataSource.signIn(
        email: email,
        password: password,
      );
      print('✅ REPOSITORY - Usuario obtenido, guardando en caché');
      await localDataSource.cacheUser(user);
      return Right(user);
    } on ServerException catch (e) {
      print('❌ REPOSITORY - ServerException: ${e.message}');
      return Left(ServerFailure(e.message));
    } catch (e) {
      print('❌ REPOSITORY - Error inesperado: ${e.toString()}');
      return Left(ServerFailure('Error inesperado: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.signUp(
        name: name,
        email: email,
        password: password,
      );
      await localDataSource.cacheUser(user);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error inesperado: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      await localDataSource.clearCache();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error inesperado al cerrar sesión'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      // Intentar obtener usuario del caché local
      final cachedUser = await localDataSource.getCachedUser();

      // Si existe en caché y no ha expirado, retornarlo
      if (cachedUser != null) {
        if (cachedUser.expiresAt != null && cachedUser.expiresAt!.isAfter(DateTime.now())) {
          return Right(cachedUser);
        }
      }

      // Si no hay caché válido, obtener de Cognito
      final remoteUser = await remoteDataSource.getCurrentUser();

      if (remoteUser != null) {
        await localDataSource.cacheUser(remoteUser);
        return Right(remoteUser);
      }

      return const Right(null);
    } on CacheException catch (e) {
      // Si falla el caché, intentar obtener de Cognito
      try {
        final remoteUser = await remoteDataSource.getCurrentUser();
        if (remoteUser != null) {
          await localDataSource.cacheUser(remoteUser);
          return Right(remoteUser);
        }
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return const Right(null);
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword({
    required String email,
  }) async {
    try {
      await remoteDataSource.forgotPassword(email: email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error inesperado al solicitar recuperación'));
    }
  }

  @override
  Future<Either<Failure, void>> confirmResetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.confirmResetPassword(
        email: email,
        code: code,
        newPassword: newPassword,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error inesperado al restablecer contraseña'));
    }
  }

  @override
  Future<Either<Failure, void>> verifyCode({
    required String email,
    required String code,
  }) async {
    try {
      await remoteDataSource.verifyCode(
        email: email,
        code: code,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error inesperado al verificar código'));
    }
  }

  @override
  Future<Either<Failure, User>> verifyAndSetPassword({
    required String email,
    required String verificationCode,
    required String temporaryPassword,
    required String newPassword,
  }) async {
    try {
      final user = await remoteDataSource.verifyAndSetPassword(
        email: email,
        verificationCode: verificationCode,
        temporaryPassword: temporaryPassword,
        newPassword: newPassword,
      );
      await localDataSource.cacheUser(user);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error inesperado al verificar cuenta'));
    }
  }
}
