import 'package:equatable/equatable.dart';

class ApiKeyResponse extends Equatable {
  final String id;
  final String key;
  final String name;
  final DateTime expiresAt;

  const ApiKeyResponse({
    required this.id,
    required this.key,
    required this.name,
    required this.expiresAt,
  });

  @override
  List<Object?> get props => [id, key, name, expiresAt];
}
