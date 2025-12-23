# Guía de uso: Generación y almacenamiento de API Key

Esta guía explica cómo generar y guardar la API Key del usuario después de la autenticación.

## Flujo de trabajo

1. El usuario se autentica (login exitoso)
2. Se obtiene el ID del usuario autenticado
3. Se genera una API Key mediante el endpoint del backend
4. La API Key se guarda automáticamente en SharedPreferences
5. La API Key se usa en futuras peticiones

## Ejemplo de implementación

### 1. En tu BLoC o controlador de autenticación

Después de que el usuario inicie sesión exitosamente:

```dart
import 'package:booster/injection_container.dart' as di;
import 'package:booster/features/auth/domain/usecases/generate_api_key.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GenerateApiKey generateApiKey;

  // ... otros parámetros del constructor

  AuthBloc({
    required this.generateApiKey,
    // ... otros use cases
  }) : super(AuthInitial()) {
    on<SignInEvent>(_onSignIn);
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    // 1. Autenticar al usuario
    final result = await signIn(SignInParams(
      email: event.email,
      password: event.password,
    ));

    await result.fold(
      (failure) async {
        emit(AuthError(failure.message));
      },
      (user) async {
        // 2. Usuario autenticado exitosamente
        emit(AuthAuthenticated(user));

        // 3. Generar y guardar API Key
        final apiKeyResult = await generateApiKey(GenerateApiKeyParams(
          userId: user.id,
          name: 'Mobile App Key',
          expiresInDays: 90,
        ));

        apiKeyResult.fold(
          (failure) {
            // Manejar error (opcional: mostrar notificación)
            print('Error al generar API Key: ${failure.message}');
          },
          (apiKeyResponse) {
            // API Key generada y guardada exitosamente
            print('API Key generada: ${apiKeyResponse.key}');
            print('Expira en: ${apiKeyResponse.expiresAt}');
          },
        );
      },
    );
  }
}
```

### 2. Uso directo del servicio (alternativa simple)

Si prefieres un enfoque más directo:

```dart
import 'package:booster/injection_container.dart' as di;
import 'package:booster/features/auth/domain/usecases/generate_api_key.dart';

// Después del login exitoso
final generateApiKey = di.sl<GenerateApiKey>();

final result = await generateApiKey(GenerateApiKeyParams(
  userId: 'user-id-aqui',
  name: 'Mobile App Key',
  expiresInDays: 90,
));

result.fold(
  (failure) => print('Error: ${failure.message}'),
  (apiKeyResponse) {
    print('API Key: ${apiKeyResponse.key}');
    print('ID: ${apiKeyResponse.id}');
    print('Nombre: ${apiKeyResponse.name}');
    print('Expira: ${apiKeyResponse.expiresAt}');
  },
);
```

### 3. Obtener la API Key guardada

Para obtener la API Key guardada en SharedPreferences:

```dart
import 'package:booster/injection_container.dart' as di;
import 'package:booster/features/auth/domain/repositories/api_key_repository.dart';

final apiKeyRepository = di.sl<ApiKeyRepository>();

// Verificar si existe
if (apiKeyRepository.hasStoredApiKey()) {
  // Obtener la key
  final apiKey = apiKeyRepository.getStoredApiKey();
  print('API Key guardada: $apiKey');
}
```

### 4. Limpiar la API Key (al cerrar sesión)

```dart
import 'package:booster/injection_container.dart' as di;
import 'package:booster/features/auth/domain/repositories/api_key_repository.dart';

final apiKeyRepository = di.sl<ApiKeyRepository>();

final result = await apiKeyRepository.clearStoredApiKey();

result.fold(
  (failure) => print('Error al limpiar: ${failure.message}'),
  (_) => print('API Key eliminada'),
);
```

## Endpoint del backend

La implementación hace una petición POST a:

```
POST {API_URL}/api/users/{user_id}/api-keys
```

### Headers:
```json
{
  "Content-Type": "application/json"
}
```

### Body:
```json
{
  "name": "Mi API Key",
  "expires_in_days": 90
}
```

### Respuesta esperada:
```json
{
  "id": "api-key-uuid",
  "key": "sk_live_abc123...",
  "name": "Mi API Key",
  "expires_at": "2024-04-01T00:00:00Z"
}
```

## Notas importantes

1. **La API Key solo se muestra una vez**: Asegúrate de guardarla inmediatamente después de generarla.

2. **Sin autenticación requerida**: El endpoint NO requiere headers de autenticación según la configuración actual del backend.

3. **Almacenamiento seguro**: La API Key se guarda en SharedPreferences. Para mayor seguridad, considera usar `flutter_secure_storage` en producción.

4. **Expiración**: Recuerda que la API Key tiene una fecha de expiración. Puedes verificarla con `apiKeyResponse.expiresAt`.

5. **Validación de formato**: El servicio incluye validación del formato de la API Key:
   - Debe comenzar con `sk_live_` o `sk_test_`
   - Seguido de 64 caracteres hexadecimales

## Arquitectura

La implementación sigue Clean Architecture:

- **Domain Layer**:
  - `ApiKeyResponse` (Entity): lib/features/auth/domain/entities/api_key_response.dart:1
  - `ApiKeyRepository` (Interface): lib/features/auth/domain/repositories/api_key_repository.dart:1
  - `GenerateApiKey` (Use Case): lib/features/auth/domain/usecases/generate_api_key.dart:1

- **Data Layer**:
  - `ApiKeyResponseModel` (Model): lib/features/auth/data/models/api_key_response_model.dart:1
  - `ApiKeyRepositoryImpl`: lib/features/auth/data/repositories/api_key_repository_impl.dart:1
  - `ApiKeyRemoteDataSource`: lib/features/auth/data/datasources/api_key_remote_data_source.dart:1

- **Core**:
  - `ApiKeyService`: lib/core/services/api_key_service.dart:1
