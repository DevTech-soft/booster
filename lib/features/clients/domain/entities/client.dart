import 'package:equatable/equatable.dart';

abstract class Client  extends Equatable{
  final String id;
  final String tenantId;
  final String name;
  final String email;
  final String? dni;

  final String? maritalStatus; 
  final String? address;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Client({
    required this.id,
    required this.tenantId,
    required this.name,
    required this.email,
    this.dni,
    this.maritalStatus,
    this.address,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  List<Object?> get props => [
        id,
        tenantId,
        name,
        email,
        dni,
        maritalStatus,
        address,
        isActive,
        createdAt,
        updatedAt,
      ];
}