import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? token;
  final String? refreshToken;
  final DateTime? expiresAt;
  final String? advisorId;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.token,
    this.refreshToken,
    this.expiresAt,
    this.advisorId,
  });

  @override
  List<Object?> get props => [id, name, email, token, refreshToken, expiresAt, advisorId];
}
