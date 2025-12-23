import 'dart:convert';
import 'package:booster/core/error/exceptions.dart';
import 'package:booster/core/services/api_key_service.dart';
import 'package:booster/features/projects/data/models/project_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

abstract class ProjectsRemoteDataSource {
  /// Obtiene la lista de proyectos desde la API
  /// Parámetros opcionales:
  /// - [tenantId]: Filtrar proyectos por tenant
  /// - [limit]: Número de resultados (por defecto: 50)
  /// - [offset]: Offset para paginación (por defecto: 0)
  Future<List<ProjectModel>> getProjects({
    String? tenantId,
    int limit = 50,
    int offset = 0,
  });

  /// Obtiene un proyecto específico por ID
  Future<ProjectModel> getProject(String projectId);
}

class ProjectsRemoteDataSourceImpl implements ProjectsRemoteDataSource {
  final http.Client client;
  final ApiKeyService apiKeyService;

  ProjectsRemoteDataSourceImpl({
    required this.client,
    required this.apiKeyService,
  });

  String get _baseUrl => dotenv.env['API_URL'] ?? '';

  Map<String, String> get _headers {
    final apiKey = apiKeyService.getApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      throw ServerException('API Key no configurada');
    }

    return {
      'Content-Type': 'application/json',
      'X-API-Key': apiKey,
    };
  }

  @override
  Future<List<ProjectModel>> getProjects({
    String? tenantId,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      // Construir query parameters
      final queryParams = <String, String>{
        'limit': limit.toString(),
        'offset': offset.toString(),
      };

      if (tenantId != null && tenantId.isNotEmpty) {
        queryParams['tenant_id'] = tenantId;
      }

      final uri = Uri.parse('$_baseUrl/api/projects').replace(
        queryParameters: queryParams,
      );

      final response = await client.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final projectsList = jsonData['projects'] as List<dynamic>;

        return projectsList
            .map((json) => ProjectModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 401) {
        throw ServerException('API Key inválida o expirada');
      } else if (response.statusCode == 403) {
        throw ServerException('Permiso denegado');
      } else {
        final errorData =
            response.body.isNotEmpty ? json.decode(response.body) : {};
        final message = errorData['message'] ?? 'Error al obtener proyectos';
        throw ServerException(message);
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Error de conexión: ${e.toString()}');
    }
  }

  @override
  Future<ProjectModel> getProject(String projectId) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/projects/$projectId');
      final response = await client.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return ProjectModel.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw ServerException('API Key inválida o expirada');
      } else if (response.statusCode == 403) {
        throw ServerException('Permiso denegado');
      } else if (response.statusCode == 404) {
        throw ServerException('Proyecto no encontrado');
      } else {
        final errorData =
            response.body.isNotEmpty ? json.decode(response.body) : {};
        final message = errorData['message'] ?? 'Error al obtener proyecto';
        throw ServerException(message);
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Error de conexión: ${e.toString()}');
    }
  }
}
