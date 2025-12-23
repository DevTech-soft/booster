import 'dart:convert';
import 'package:booster/core/error/exceptions.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/api_key_response_model.dart';

abstract class ApiKeyRemoteDataSource {
  /// Genera una API Key para un usuario específico
  ///
  /// [userId]: ID del usuario
  /// [name]: Nombre descriptivo para la API Key
  /// [expiresInDays]: Días hasta que expire la API Key (default: 90)
  ///
  /// Retorna la información completa de la API Key generada
  Future<ApiKeyResponseModel> generateApiKey({
    required String userId,
    String name = 'Mobile App Key',
    int expiresInDays = 90,
  });
}

class ApiKeyRemoteDataSourceImpl implements ApiKeyRemoteDataSource {
  final http.Client client;

  ApiKeyRemoteDataSourceImpl({required this.client});

  String get _baseUrl => dotenv.env['API_URL'] ?? '';

  @override
  Future<ApiKeyResponseModel> generateApiKey({
    required String userId,
    String name = 'Mobile App Key',
    int expiresInDays = 90,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/users/$userId/api-keys');

      final headers = {
        'Content-Type': 'application/json',
      };

      final body = json.encode({
        'name': name,
        'expires_in_days': expiresInDays,
      });

      final response = await client.post(
        uri,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;

        return ApiKeyResponseModel.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw ServerException('No autorizado para generar API Key');
      } else if (response.statusCode == 403) {
        throw ServerException('Permiso denegado para generar API Key');
      } else if (response.statusCode == 404) {
        throw ServerException('Usuario no encontrado');
      } else {
        final errorData =
            response.body.isNotEmpty ? json.decode(response.body) : {};
        final message = errorData['message'] ?? 'Error al generar API Key';
        throw ServerException(message);
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Error de conexión al generar API Key: ${e.toString()}');
    }
  }
}
