import 'package:booster/features/clients/domain/entities/client.dart';

class ClientModel extends Client {
 const ClientModel({
    required super.id,
    required super.tenantId,
    required super.name,
    required super.email,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'],
      tenantId: json['tenant_id'],
      name: json['name'],
      email: json['email'],
      isActive: json['is_active'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenant_id': tenantId,
      'name': name,
      'email': email,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
  factory ClientModel.fromEntity(Client client) {
    return ClientModel(
      id: client.id,
      tenantId: client.tenantId,
      name: client.name,
      email: client.email,
      isActive: client.isActive,
      createdAt: client.createdAt,
      updatedAt: client.updatedAt,
    );
  }
}
