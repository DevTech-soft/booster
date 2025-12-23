import 'dart:developer';

import 'package:booster/features/auth/domain/usecases/generate_api_key.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/confirm_reset_password.dart';
import '../../domain/usecases/forgot_password.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up.dart';
import '../../domain/usecases/verify_and_set_password.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn signIn;
  final SignUp signUp;
  final SignOut signOut;
  final GetCurrentUser getCurrentUser;
  final ForgotPassword forgotPassword;
  final ConfirmResetPassword confirmResetPassword;
  final VerifyAndSetPassword verifyAndSetPassword;
  final GenerateApiKey generateApiKey;

  AuthBloc({
    required this.signIn,
    required this.signUp,
    required this.signOut,
    required this.getCurrentUser,
    required this.forgotPassword,
    required this.confirmResetPassword,
    required this.verifyAndSetPassword,
    required this.generateApiKey,
  }) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<ConfirmResetPasswordRequested>(_onConfirmResetPasswordRequested);
    on<VerifyAndSetPasswordRequested>(_onVerifyAndSetPasswordRequested);
    
  }

  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await getCurrentUser(const NoParams());

    result.fold(
      (failure) => emit(Unauthenticated()),
      (user) {
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(Unauthenticated());
        }
      },
    );
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    

    emit(AuthLoading());

    final result = await signIn(
      SignInParams(
        email: event.email,
        password: event.password,
      ),
    );


    result.fold(
      (failure) {
        emit(AuthError('Error al iniciar sesión: ${failure.message}'));
      },
      (user)async {
        emit(Authenticated(user));
        log("voy a generar api key");
         final apiKeyResult = await generateApiKey(GenerateApiKeyParams(
          userId: user.id,
          name: 'Mobile App Key',
          expiresInDays: 90,
        ));

         apiKeyResult.fold(
          (failure) {
            // Manejar error (opcional: mostrar notificación)
            log('Error al generar API Key: ${failure.message}');
          },
          (apiKeyResponse) {
            log('API Key generada: ${apiKeyResponse.key}');
          },
        );
      },
    );
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await signUp(
      SignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(const AuthError('Error al registrar usuario. Intenta nuevamente.')),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await signOut(const NoParams());

    result.fold(
      (failure) => emit(const AuthError('Error al cerrar sesión.')),
      (_) => emit(Unauthenticated()),
    );
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await forgotPassword(
      ForgotPasswordParams(email: event.email),
    );

    result.fold(
      (failure) => emit(const AuthError('Error al enviar código de recuperación.')),
      (_) => emit(ForgotPasswordCodeSent(event.email)),
    );
  }

  Future<void> _onConfirmResetPasswordRequested(
    ConfirmResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await confirmResetPassword(
      ConfirmResetPasswordParams(
        email: event.email,
        code: event.code,
        newPassword: event.newPassword,
      ),
    );

    result.fold(
      (failure) => emit(const AuthError('Error al restablecer contraseña.')),
      (_) => emit(Unauthenticated()),
    );
  }

  Future<void> _onVerifyAndSetPasswordRequested(
    VerifyAndSetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await verifyAndSetPassword(
      VerifyAndSetPasswordParams(
        email: event.email,
        verificationCode: event.verificationCode,
        temporaryPassword: event.temporaryPassword,
        newPassword: event.newPassword,
      ),
    );

    result.fold(
      (failure) => emit(AuthError('Error al verificar y establecer contraseña. ${failure.message}')),
      (user) => emit(Authenticated(user)),
    );
  }
}
