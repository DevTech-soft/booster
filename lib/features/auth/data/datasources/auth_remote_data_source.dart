import 'dart:developer';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../../../../core/config/cognito_config.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({required String email, required String password});

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<UserModel?> getCurrentUser();

  Future<void> forgotPassword({required String email});

  Future<void> confirmResetPassword({
    required String email,
    required String code,
    required String newPassword,
  });

  Future<void> verifyCode({required String email, required String code});

  Future<UserModel> verifyAndSetPassword({
    required String email,
    required String verificationCode,
    required String temporaryPassword,
    required String newPassword,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );

      if (result.isSignedIn) {
        final user = await _getUserFromSession();
        return user;
      } else if (result.nextStep.signInStep ==
          AuthSignInStep.confirmSignInWithNewPassword) {
        throw ServerException(
          'Se requiere cambiar la contraseña. Por favor, completa el proceso de verificación.',
        );
      } else {
        throw ServerException('No se pudo completar el inicio de sesión');
      }
    } on AuthException catch (e) {
      throw ServerException('Error de autenticación: ${e.message}');
    } catch (e) {
      throw ServerException('Error inesperado: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userAttributes = <AuthUserAttributeKey, String>{
        AuthUserAttributeKey.email: email,
        AuthUserAttributeKey.name: name,
      };

      final result = await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: SignUpOptions(userAttributes: userAttributes),
      );

      if (result.isSignUpComplete) {
        return await signIn(email: email, password: password);
      } else {
        throw ServerException('No se pudo completar el registro');
      }
    } on AuthException catch (e) {
      throw ServerException('Error de registro: ${e.message}');
    } catch (e) {
      throw ServerException('Error inesperado: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
    } on AuthException catch (e) {
      throw ServerException('Error al cerrar sesión: ${e.message}');
    } catch (e) {
      throw ServerException('Error inesperado: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();

      if (session.isSignedIn) {
        return await _getUserFromSession();
      }

      return null;
    } on AuthException {
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      await Amplify.Auth.resetPassword(username: email);
    } on AuthException catch (e) {
      throw ServerException('Error al solicitar recuperación: ${e.message}');
    } catch (e) {
      throw ServerException('Error inesperado: ${e.toString()}');
    }
  }

  @override
  Future<void> confirmResetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      await Amplify.Auth.confirmResetPassword(
        username: email,
        newPassword: newPassword,
        confirmationCode: code,
      );
    } on AuthException catch (e) {
      throw ServerException('Error al restablecer contraseña: ${e.message}');
    } catch (e) {
      throw ServerException('Error inesperado: ${e.toString()}');
    }
  }

  @override
  Future<void> verifyCode({required String email, required String code}) async {
    try {
      await Amplify.Auth.confirmSignUp(username: email, confirmationCode: code);
    } on AuthException catch (e) {
      throw ServerException('Error al verificar código: ${e.message}');
    } catch (e) {
      throw ServerException('Error inesperado: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> verifyAndSetPassword({
    required String email,
    required String verificationCode,
    required String temporaryPassword,
    required String newPassword,
  }) async {
    try {
      // Paso 1: Confirmar el código de verificación
      await Amplify.Auth.confirmSignUp(
        username: email,
        confirmationCode: verificationCode,
      );

      // Paso 2: Iniciar sesión con la contraseña temporal
      final signInResult = await Amplify.Auth.signIn(
        username: email,
        password: temporaryPassword,
      );

      // Paso 3: Verificar si requiere cambio de contraseña
      if (signInResult.nextStep.signInStep ==
          AuthSignInStep.confirmSignInWithNewPassword) {
        // Paso 4: Confirmar con la nueva contraseña
        final confirmResult = await Amplify.Auth.confirmSignIn(
          confirmationValue: newPassword,
        );

        if (confirmResult.isSignedIn) {
          // Paso 5: Obtener y retornar el usuario autenticado
          final user = await _getUserFromSession();

          return user;
        } else {
          throw ServerException('No se pudo completar el cambio de contraseña');
        }
      } else if (signInResult.isSignedIn) {
        // Si ya está autenticado, cambiar la contraseña manualmente
        await Amplify.Auth.updatePassword(
          oldPassword: temporaryPassword,
          newPassword: newPassword,
        );
        final user = await _getUserFromSession();
        return user;
      } else {
        throw ServerException('Estado de autenticación inesperado');
      }
    } on AuthException catch (e) {
      throw ServerException(
        'Error al verificar y establecer contraseña: ${e.message}',
      );
    } catch (e) {
      throw ServerException('Error inesperado: ${e.toString()}');
    }
  }

  Future<UserModel> _getUserFromSession() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      final attributes = await Amplify.Auth.fetchUserAttributes();

      String? email;
      String? name;

      for (var attribute in attributes) {
        if (attribute.userAttributeKey == AuthUserAttributeKey.email) {
          email = attribute.value;
        } else if (attribute.userAttributeKey == AuthUserAttributeKey.name) {
          name = attribute.value;
        }
      }

      final session =
          await Amplify.Auth.fetchAuthSession() as CognitoAuthSession;

      return UserModel(
        id: user.userId,
        name: name ?? email ?? 'Unknown',
        email: email ?? '',
        token: session.userPoolTokensResult.value.accessToken.raw,
        refreshToken: session.userPoolTokensResult.value.refreshToken,
        expiresAt:
            session.userPoolTokensResult.value.accessToken.claims.expiration,
      );
    } catch (e) {
      throw ServerException(
        'Error al obtener datos del usuario: ${e.toString()}',
      );
    }
  }
}
