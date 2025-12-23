import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/api_key_response.dart';

abstract class ApiKeyRepository {
  /// Genera una API Key para un usuario y la guarda localmente
  ///
  /// [userId]: ID del usuario autenticado
  /// [name]: Nombre descriptivo para la API Key
  /// [expiresInDays]: Días hasta que expire la API Key
  ///
  /// Retorna la información completa de la API Key generada
  Future<Either<Failure, ApiKeyResponse>> generateAndSaveApiKey({
    required String userId,
    String name = 'Mobile App Key',
    int expiresInDays = 90,
  });

  /// Obtiene la API Key guardada localmente
  ///
  /// Retorna la API Key si existe, null si no
  String? getStoredApiKey();

  /// Verifica si hay una API Key guardada
  bool hasStoredApiKey();

  /// Elimina la API Key guardada localmente
  Future<Either<Failure, void>> clearStoredApiKey();
}
