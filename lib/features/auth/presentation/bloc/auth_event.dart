import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class SignUpRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const SignUpRequested({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}

class SignOutRequested extends AuthEvent {}

class ForgotPasswordRequested extends AuthEvent {
  final String email;

  const ForgotPasswordRequested({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}

class ConfirmResetPasswordRequested extends AuthEvent {
  final String email;
  final String code;
  final String newPassword;

  const ConfirmResetPasswordRequested({
    required this.email,
    required this.code,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [email, code, newPassword];
}

class VerifyAndSetPasswordRequested extends AuthEvent {
  final String email;
  final String verificationCode;
  final String temporaryPassword;
  final String newPassword;

  const VerifyAndSetPasswordRequested({
    required this.email,
    required this.verificationCode,
    required this.temporaryPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [email, verificationCode, temporaryPassword, newPassword];
}

class LogoutRequested extends AuthEvent {}
