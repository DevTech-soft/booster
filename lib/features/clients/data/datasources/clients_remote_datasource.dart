import 'dart:convert';
import 'dart:developer';
import 'package:booster/core/error/exceptions.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

abstract class ClientsRemoteDatasource {
  Future<Map<String, dynamic>> createClient({
    required String fullName,
    required String dni,
    required int age,
    required String maritalStatus,
    required String tenantId,
  });

  Future<Map<String, dynamic>> getClientByDni(String dni);
}

class ClientsRemoteDatasourceImpl implements ClientsRemoteDatasource {
  final String apiUrl = dotenv.env['API_URL'] ?? '';
  final String apiKey = dotenv.env['API_KEY'] ?? '';

  @override
  Future<Map<String, dynamic>> createClient({
    required String fullName,
    required String dni,
    required int age,
    required String maritalStatus,
    required String tenantId,
  }) async {
    log('Creating client: $fullName, DNI: $dni');

    final response = await http.post(
      Uri.parse('$apiUrl/api/clients'),
      headers: {'Content-Type': 'application/json', 'X-API-Key': apiKey},
      body: jsonEncode({
        'tenant_id': tenantId,
        'full_name': fullName,
        'dni': dni,
        'age': age,
        'marital_status': maritalStatus,
      }),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ServerException(
        'Error creating client: ${response.body} (${response.statusCode})',
      );
    }

    final data = jsonDecode(response.body);
    log('Client created with ID: ${data['id']}');

    return data;
  }

  @override
  Future<Map<String, dynamic>> getClientByDni(String dni) async {
    log('Searching client by DNI: $dni');

    final response = await http.get(
      Uri.parse('$apiUrl/api/clients/dni/$dni'),
      headers: {'Content-Type': 'application/json', 'X-API-Key': apiKey},
    );
    log('body response cliente${response.body}');
    if (response.statusCode != 200) {
      throw ServerException(
        'Error getting client: ${response.body} (${response.statusCode})',
      );
    }

    final data = jsonDecode(response.body);
    log('Client found: ${data['full_name']}');

    return data;
  }
}
