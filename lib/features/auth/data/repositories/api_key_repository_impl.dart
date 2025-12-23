import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/api_key_service.dart';
import '../../domain/entities/api_key_response.dart';
import '../../domain/repositories/api_key_repository.dart';
import '../datasources/api_key_remote_data_source.dart';

class ApiKeyRepositoryImpl implements ApiKeyRepository {
  final ApiKeyRemoteDataSource remoteDataSource;
  final ApiKeyService apiKeyService;

  ApiKeyRepositoryImpl({
    required this.remoteDataSource,
    required this.apiKeyService,
  });

  @override
  Future<Either<Failure, ApiKeyResponse>> generateAndSaveApiKey({
    required String userId,
    String name = 'Mobile App Key',
    int expiresInDays = 90,
  }) async {
    try {
      // Generar API Key en el backend
      final apiKeyResponse = await remoteDataSource.generateApiKey(
        userId: userId,
        name: name,
        expiresInDays: expiresInDays,
      );

      // Guardar la API Key localmente
      final saved = await apiKeyService.saveApiKey(apiKeyResponse.key);

      if (!saved) {
        return Left(CacheFailure('Error al guardar la API Key localmente'));
      }

      return Right(apiKeyResponse);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error inesperado al generar API Key: ${e.toString()}'));
    }
  }

  @override
  String? getStoredApiKey() {
    return apiKeyService.getApiKey();
  }

  @override
  bool hasStoredApiKey() {
    return apiKeyService.hasApiKey();
  }

  @override
  Future<Either<Failure, void>> clearStoredApiKey() async {
    try {
      final cleared = await apiKeyService.clearApiKey();

      if (!cleared) {
        return Left(CacheFailure('Error al eliminar la API Key'));
      }

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Error inesperado al eliminar API Key'));
    }
  }
}
