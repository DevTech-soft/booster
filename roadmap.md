# Booster - Roadmap de Desarrollo

## Estado Actual del Proyecto

### ✅ Features Completamente Implementados (Clean Architecture)

#### **Projects Feature**
- [x] **Domain Layer**:
  - [x] Entity: `Project` (id, name, status, interviews, updatedAt, isSelected)
  - [x] Repository Interface: `ProjectsRepository`
  - [x] UseCase: `GetProjects`
- [x] **Data Layer**:
  - [x] Model: `ProjectModel` con serialización JSON
  - [x] DataSource: `ProjectsLocalDataSource` + Impl (5 proyectos hardcodeados)
  - [x] Repository Impl: `ProjectsRepositoryImpl`
- [x] **Presentation Layer**:
  - [x] **ProjectsBloc**: Gestión de carga y selección de proyectos
    - Estados: Initial, Loading, Loaded, Error
    - Eventos: LoadProjects, ToggleSelection, SelectAll, DeselectAll
  - [x] **RecordingBloc**: Gestión completa de grabación/reproducción de audio
    - Estados: Initial, InProgress, Stopped, Playing, Paused, Error
    - Eventos: Start, Stop, Play, Pause, Seek, UpdatePosition
    - Integración: `record` package + `just_audio` package
    - Features: Waveform en tiempo real, control de tiempo (HH:MM:SS), cuenta regresiva
  - [x] Páginas: `ProjectsPage`, `RecordPage`
  - [x] Widgets: `ProjectsTable`, `RecordStateWidget`, `ActionBar`, `ActionItem`
- [x] **Dependency Injection**: Configurado en `injection_container.dart`

### ✅ Features Completamente Implementados (Clean Architecture)

#### **Auth Feature**
- [x] **Domain Layer**:
  - [x] Entities: `User`, `AuthCredentials`
  - [x] Repository Interface: `AuthRepository`
  - [x] UseCases: `SignIn`, `SignUp`, `SignOut`, `GetCurrentUser`, `ForgotPassword`, `ConfirmResetPassword`
- [x] **Data Layer**:
  - [x] Model: `UserModel` con serialización JSON
  - [x] DataSource Remote: `AuthRemoteDataSourceImpl` (AWS Amplify/Cognito)
  - [x] DataSource Local: `AuthLocalDataSourceImpl` (SharedPreferences)
  - [x] Repository Impl: `AuthRepositoryImpl`
- [x] **Presentation Layer**:
  - [x] **AuthBloc**: Gestión completa de autenticación
    - Estados: Initial, Loading, Authenticated, Unauthenticated, Error, ForgotPasswordCodeSent
    - Eventos: AppStarted, SignInRequested, SignUpRequested, SignOutRequested, ForgotPasswordRequested, ConfirmResetPasswordRequested
  - [x] Páginas: `LoginPage`, `RegisterPage`, `ForgotPasswordPage`
  - [x] Integración completa con BLoC
  - [x] Persistencia de sesión con caché local
  - [x] Verificación automática al iniciar app
- [x] **Dependency Injection**: Configurado en `injection_container.dart`
- [x] **Configuración AWS Cognito**: Archivo con placeholders listos para credenciales

#### **Records Feature**
- [x] Páginas creadas:
  - [x] `AudioDetailsPage`: Vista completa de audio con:
    - Barra de búsqueda en transcripción
    - Header con título y timestamp
    - Reproductor de audio (play, pause, seek ±5s, delete)
    - Transcripción hardcodeada
    - Botón Guardar
- [ ] Domain Layer: No implementado
- [ ] Data Layer: No implementado
- [ ] BLoC: No implementado

#### **Dashboard Feature**
- [x] `DashboardPage`: Página de bienvenida con botón "INICIAR AUDIO"
- [ ] Domain/Data/BLoC: No implementados

#### **General Info Feature**
- [x] `WelcomePage`: Pantalla de bienvenida con logo y botón "COMENZAR"

#### **Layout**
- [x] `MainLayoutPage`: Layout principal con BottomNavigationBar (5 tabs)
  - [0] Projects, [1] Profile (vacío), [2] Dashboard, [3] Audios (vacío), [4] Settings (vacío)

### ✅ Core/Infraestructura
- [x] **Tema**: Colores, tipografía, espaciados definidos
- [x] **Widgets Compartidos**: 7 widgets (AppHeader, PrimaryButton, CustomTextField, etc.)
- [x] **Utils**: Logger, validators, formatters
- [x] **Error Handling**: Failures y Exceptions definidos
- [x] **UseCase Base**: Clase abstracta genérica
- [x] **Dependency Injection**: GetIt configurado

---

## 📋 Próximos Pasos

### ~~1️⃣ **PRIORIDAD ALTA**: Completar Feature Auth con Clean Architecture~~ ✅ **COMPLETADO**
**Estado**: ✅ **IMPLEMENTACIÓN COMPLETA**

**Implementado el**: 2025-12-14

#### ✅ Completado:

**A. Domain Layer** (`lib/features/auth/domain/`)
- [x] Entidades: `User`, `AuthCredentials`
- [x] Repository Interface: `AuthRepository`
- [x] Casos de uso: `SignIn`, `SignUp`, `SignOut`, `GetCurrentUser`, `ForgotPassword`, `ConfirmResetPassword`

**B. Data Layer** (`lib/features/auth/data/`)
- [x] Model: `UserModel`
- [x] DataSources: `AuthRemoteDataSourceImpl` (AWS Amplify), `AuthLocalDataSourceImpl` (SharedPreferences)
- [x] Repository: `AuthRepositoryImpl`

**C. Presentation Layer** (`lib/features/auth/presentation/`)
- [x] AuthBloc con todos los estados y eventos
- [x] `LoginPage`, `RegisterPage`, `ForgotPasswordPage` conectadas con BLoC
- [x] Guards de navegación implementados en `main.dart` (AuthWrapper)

**D. Configuración AWS Cognito**
- [x] Archivo de configuración creado: `lib/core/config/cognito_config.dart`
- [x] Placeholders listos para credenciales
- [x] Documentación de setup: `COGNITO_SETUP.md`
- [ ] ⚠️ **PENDIENTE**: Configurar credenciales reales cuando se reciban

**E. Dependency Injection**
- [x] `injection_container.dart` actualizado con todos los componentes de Auth
- [x] SharedPreferences configurado

---

### 1️⃣ **PRIORIDAD ALTA**: Completar Feature Records con Clean Architecture
**Estado**: ✅ UI de AudioDetailsPage creada | ❌ Domain/Data/BLoC pendientes

**Objetivo**: Implementar gestión de audios grabados y transcripciones

#### Tareas:

**A. Domain Layer** (`lib/features/records/domain/`)
- [ ] Crear entidades:
  - [ ] `AudioRecord` (id, projectId, title, audioPath, duration, timestamp, transcription)
  - [ ] `Transcription` (id, recordId, text, segments, language)
  - [ ] `TranscriptionSegment` (startTime, endTime, text, confidence)
- [ ] Crear repositories:
  - [ ] `RecordsRepository` (abstract)
  - [ ] `TranscriptionRepository` (abstract)
- [ ] Crear casos de uso:
  - [ ] `GetAllRecords(projectId?)` → `Either<Failure, List<AudioRecord>>`
  - [ ] `GetRecordById(id)` → `Either<Failure, AudioRecord>`
  - [ ] `SaveRecord(AudioRecord)` → `Either<Failure, AudioRecord>`
  - [ ] `UpdateRecord(AudioRecord)` → `Either<Failure, AudioRecord>`
  - [ ] `DeleteRecord(id)` → `Either<Failure, void>`
  - [ ] `GetTranscription(recordId)` → `Either<Failure, Transcription>`
  - [ ] `SearchInTranscription(query, recordId)` → `Either<Failure, List<Match>>`

**B. Data Layer** (`lib/features/records/data/`)
- [ ] Crear modelos:
  - [ ] `AudioRecordModel extends AudioRecord`
  - [ ] `TranscriptionModel extends Transcription`
- [ ] Crear datasources:
  - [ ] `RecordsRemoteDataSource` (API para sincronizar audios)
  - [ ] `RecordsLocalDataSource` (almacenamiento local - SQLite/Hive)
  - [ ] `TranscriptionRemoteDataSource` (API de transcripción)
- [ ] Implementar repositories:
  - [ ] `RecordsRepositoryImpl`
  - [ ] `TranscriptionRepositoryImpl`

**C. Presentation Layer** (`lib/features/records/presentation/`)
- [ ] Crear **RecordsListBloc**:
  - Estados: Loading, Loaded(records), Error
  - Eventos: LoadRecords, RefreshRecords, DeleteRecord
- [ ] Crear **AudioDetailsBloc**:
  - Estados: Loading, Loaded(record, transcription), Saving, Error
  - Eventos: LoadAudioDetails, SaveRecord, UpdateTitle, SearchInTranscription
- [ ] Crear página `RecordsListPage` (tab "Audios" en BottomNav)
- [ ] Conectar `AudioDetailsPage` con AudioDetailsBloc
- [ ] Implementar funcionalidad de búsqueda en transcripción

**D. Integración con RecordingBloc**
- [ ] Cuando se guarda un audio en `RecordPage`:
  - [ ] Llamar a `SaveRecord` usecase
  - [ ] Asociar audio con proyecto seleccionado
  - [ ] Navegar a `AudioDetailsPage` con el record guardado

---

### 2️⃣ **PRIORIDAD MEDIA**: Mejorar RecordingBloc con Clean Architecture
**Estado**: ✅ BLoC funcional | ⚠️ Podría mejorarse con casos de uso

**Nota**: RecordingBloc está en `projects` porque la grabación se inicia desde ProjectsPage/DashboardPage.
**NO es necesario moverlo a `records`** - la estructura actual es correcta.

#### Mejoras Opcionales:
- [ ] Crear casos de uso para abstraer lógica:
  - [ ] `StartRecordingUseCase`
  - [ ] `StopRecordingUseCase`
  - [ ] `PlayAudioUseCase`
  - [ ] `PauseAudioUseCase`
- [ ] Crear `AudioPlayerRepository` para abstraer just_audio
- [ ] Mantener RecordingBloc en `projects/presentation/bloc/`

---

### 3️⃣ **PRIORIDAD BAJA**: Dashboard y Otros Features

#### Dashboard
- [ ] Definir funcionalidad del Dashboard (estadísticas, accesos rápidos, etc.)
- [ ] Implementar Domain/Data/BLoC según necesidades

#### Profile, Settings, etc.
- [ ] Definir features necesarios
- [ ] Implementar según prioridad del negocio

---

## 📦 Backlog y Features Futuros

### API y Backend
- [ ] Configurar API Gateway en AWS
- [ ] Crear endpoints para:
  - [ ] Gestión de proyectos (CRUD)
  - [ ] Subida de audios a S3
  - [ ] Servicio de transcripción (AWS Transcribe o alternativa)
  - [ ] Sincronización de datos
- [ ] Implementar Lambda functions para procesamiento
- [ ] Configurar permisos IAM

### Almacenamiento Local
- [ ] Implementar base de datos local (SQLite o Hive)
- [ ] Crear esquemas para:
  - [ ] Proyectos
  - [ ] Audios
  - [ ] Transcripciones
- [ ] Implementar sincronización offline-first

### Performance y Optimización
- [ ] Implementar caché de imágenes
- [ ] Optimizar carga de listas grandes
- [ ] Implementar paginación para listados
- [ ] Lazy loading de transcripciones
- [ ] Compresión de audios antes de subir

### Testing
- [ ] Tests unitarios para casos de uso (Projects)
- [ ] Tests unitarios para BLoCs (ProjectsBloc, RecordingBloc)
- [ ] Tests de integración para repositorios
- [ ] Tests de widgets
- [ ] Tests E2E para flujos críticos

### UX/UI Mejoras
- [ ] Animaciones y transiciones
- [ ] Estados de loading más informativos
- [ ] Feedback visual al grabar/reproducir
- [ ] Modo oscuro
- [ ] Accesibilidad (a11y)

### Features Futuros
- [ ] Sincronización en segundo plano
- [ ] Notificaciones push
- [ ] Compartir audios
- [ ] Exportar transcripciones (PDF, TXT, DOCX)
- [ ] Etiquetas y categorías para audios
- [ ] Búsqueda avanzada con filtros
- [ ] Colaboración multi-usuario
- [ ] Comentarios y anotaciones en transcripciones
- [ ] Edición de transcripciones
- [ ] Versionado de audios

### Seguridad
- [ ] Encriptación de audios sensibles
- [ ] Implementar refresh token rotation
- [ ] Rate limiting en API
- [ ] Validación de inputs en frontend y backend
- [ ] Logs de auditoría

---

## 📝 Notas Técnicas

### Stack Tecnológico Actual

**Frontend:**
- **Framework:** Flutter 3.x
- **Arquitectura:** Clean Architecture + BLoC Pattern
- **State Management:** `flutter_bloc ^9.1.1`
- **Dependency Injection:** `get_it ^8.0.2`
- **Functional Programming:** `dartz ^0.10.1` (Either para errores)
- **Responsive Design:** `flutter_screenutil ^5.9.3`
- **SVG Support:** `flutter_svg ^2.0.10`

**Audio:**
- **Grabación:** `record ^6.1.0` (AAC-LC, 128kbps, 44.1kHz)
- **Reproducción:** `just_audio ^0.9.41`
- **Visualización:** Custom waveform painter

**Autenticación:**
- **AWS Cognito:** `amplify_flutter ^2.0.0`, `amplify_auth_cognito ^2.0.0`
- **Persistencia:** `shared_preferences ^2.3.3`

**Backend (Planeado):**
- **Storage:** AWS S3 (audios)
- **API:** AWS API Gateway + Lambda
- **Transcripción:** AWS Transcribe o alternativa
- **Database:** DynamoDB (opcional)

**Local Storage:**
- **Sesión:** SharedPreferences ✅
- **Archivos:** File system (path_provider) ✅
- **Datos estructurados:** SQLite o Hive (pendiente)

### Estructura del Proyecto

```
lib/
├── core/                          # Compartido entre features
│   ├── config/                    # ✅ Configuración (Cognito)
│   ├── error/                     # Failures y Exceptions
│   ├── theme/                     # Tema, colores, tipografía, espaciados
│   ├── usecases/                  # UseCase<T, Params> base
│   ├── utils/                     # Logger, validators, formatters
│   └── widgets/                   # 7 widgets reutilizables
│
├── features/                      # Features del negocio
│   ├── auth/                      # ✅✅✅ Completo (Clean Architecture)
│   ├── projects/                  # ✅✅✅ Completo (Clean Architecture)
│   ├── records/                   # ✅ UI | ❌ Domain/Data/BLoC
│   ├── dashboard/                 # ✅ UI básica
│   ├── general_info/              # ✅ UI básica
│   └── layout/                    # ✅ MainLayoutPage
│
├── injection_container.dart       # Dependency Injection
└── main.dart                      # Entry point (con AuthWrapper)
```

### Convenciones y Mejores Prácticas

**Clean Architecture:**
1. **Domain Layer** (centro, sin dependencias):
   - Entities: Objetos de negocio puros (con Equatable)
   - Repositories: Interfaces (abstract classes)
   - UseCases: Lógica de negocio (un caso de uso = una acción)

2. **Data Layer** (depende de Domain):
   - Models: Extends Entity + fromJson/toJson
   - DataSources: Abstract + Implementación (Remote/Local)
   - Repositories Impl: Implementa interface de Domain

3. **Presentation Layer** (depende de Domain):
   - BLoC: Estados + Eventos (usa UseCases)
   - Pages: UI (usa BlocBuilder/BlocListener)
   - Widgets: Componentes reutilizables

**BLoC Pattern:**
- Un BLoC por feature o pantalla compleja
- Estados: Initial, Loading, Loaded, Error (mínimo)
- Eventos: Verbos en pasado (LoadRequested, ItemSelected, etc.)
- Usar Equatable para comparación de estados
- Siempre emitir nuevo estado (inmutabilidad)

**Código:**
- Usar `Either<Failure, Success>` para manejar errores
- No usar print(), usar Logger
- Usar const cuando sea posible
- Nombrar clases y archivos en snake_case
- Un archivo por clase (excepto barrel files)

**Dependency Injection:**
- Factory: Crear nueva instancia cada vez (BLoCs)
- LazySingleton: Crear una vez cuando se necesite (Repositories, DataSources)
- Singleton: Crear inmediatamente al iniciar (no usar a menos que sea necesario)

### Relación entre Features

```
Projects ──────────┐
                   │
                   ├──> RecordingBloc (graba audio)
                   │         │
                   │         ▼
                   │    (guarda audio)
                   │         │
                   └─────────▼
Records ◄────────────── AudioRecord
   │
   └──> AudioDetailsPage (muestra transcripción)
```

**Nota Importante:**
- `RecordingBloc` permanece en `projects/` porque:
  1. La grabación se inicia desde ProjectsPage
  2. Los audios se asocian a un proyecto al grabarse
  3. Records solo gestiona audios YA grabados
- NO mover RecordingBloc a `records/`

### Dependencias Importantes

```yaml
dependencies:
  flutter_bloc: ^9.1.1          # State Management
  equatable: ^2.0.7             # Comparación de objetos
  dartz: ^0.10.1                # Either<L, R>
  get_it: ^8.0.2                # Service Locator
  record: ^6.1.0                # Audio recording
  just_audio: ^0.9.41           # Audio playback
  flutter_screenutil: ^5.9.3    # Responsive design
  flutter_svg: ^2.0.10          # SVG
  path_provider: ^2.1.5         # File paths
  intl: ^0.20.2                 # Date formatting
  amplify_flutter: ^2.0.0       # ✅ AWS Amplify
  amplify_auth_cognito: ^2.0.0  # ✅ AWS Cognito
  shared_preferences: ^2.3.3    # ✅ Local storage
  # TODO: Agregar cuando se implemente:
  # sqflite: ^x.x.x             # SQLite
  # dio: ^x.x.x                 # HTTP client
```

---

## 🎯 Respuesta a Preguntas Frecuentes

### ¿Debo mover RecordingBloc de `projects/` a `records/`?

**❌ NO**

**Razón:** RecordingBloc maneja la grabación en tiempo real, que se inicia desde ProjectsPage. Los audios grabados se asocian inmediatamente a un proyecto. El feature `records/` es para **gestionar audios YA grabados** (listar, editar, ver transcripciones, etc.). Son responsabilidades diferentes.

### ¿Por qué Projects tiene Clean Architecture completa y otros no?

**✅ Projects fue implementado como referencia** para mostrar cómo debe estructurarse un feature completo. Los demás features (Auth, Records) deben seguir el mismo patrón.

### ~~¿Qué implementar primero: Auth o Records?~~ ✅ Auth Implementado

**✅ Auth implementado exitosamente**

1. ✅ La autenticación es fundamental para el resto de la app
2. ✅ Permite implementar guards de navegación
3. ✅ Los datos de usuario estarán disponibles para asociar audios
4. **Siguiente:** Implementar Records feature

---

**Última actualización:** 2025-12-14
**Versión del Roadmap:** 2.1
**Análisis del proyecto realizado el:** 2025-12-13
**Auth Feature implementado el:** 2025-12-14
