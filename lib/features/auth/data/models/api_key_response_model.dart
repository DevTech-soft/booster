import '../../domain/entities/api_key_response.dart';

class ApiKeyResponseModel extends ApiKeyResponse {
  const ApiKeyResponseModel({
    required super.id,
    required super.key,
    required super.name,
    required super.expiresAt,
  });

  factory ApiKeyResponseModel.fromJson(Map<String, dynamic> json) {
    return ApiKeyResponseModel(
      id: json['id'] as String,
      key: json['key'] as String,
      name: json['name'] as String,
      expiresAt: DateTime.parse(json['expires_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'name': name,
      'expires_at': expiresAt.toIso8601String(),
    };
  }

  factory ApiKeyResponseModel.fromEntity(ApiKeyResponse apiKeyResponse) {
    return ApiKeyResponseModel(
      id: apiKeyResponse.id,
      key: apiKeyResponse.key,
      name: apiKeyResponse.name,
      expiresAt: apiKeyResponse.expiresAt,
    );
  }
}
