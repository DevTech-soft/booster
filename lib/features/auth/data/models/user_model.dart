import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.token,
    super.refreshToken,
    super.expiresAt,
    super.advisorId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      token: json['token'] as String?,
      refreshToken: json['refreshToken'] as String?,
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
      advisorId: json['advisorId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt?.toIso8601String(),
      'advisorId': advisorId,
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      token: user.token,
      refreshToken: user.refreshToken,
      expiresAt: user.expiresAt,
      advisorId: user.advisorId,
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? token,
    String? refreshToken,
    DateTime? expiresAt,
    String? advisorId,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      advisorId: advisorId ?? this.advisorId,
    );
  }
}
