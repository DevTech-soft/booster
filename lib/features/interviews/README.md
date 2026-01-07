# Interviews Feature

## Fase 1: Configuración Base ✅ COMPLETADA

### Estructura de Carpetas Creada

```
lib/features/interviews/
├── data/
│   ├── models/               # Modelos de datos (JSON serialization)
│   ├── datasources/          # Remote & Local datasources
│   └── repositories/         # Implementación de repositorios
├── domain/
│   ├── entities/             # Entidades de negocio
│   ├── repositories/         # Interfaces de repositorios
│   ├── usecases/            # Casos de uso
│   └── constants/           # Constantes y enums del dominio
└── presentation/
    ├── bloc/                # BLoC para manejo de estado
    ├── pages/               # Páginas de UI
    └── widgets/             # Widgets reutilizables
```

### Archivos de Configuración Creados

#### 1. Constantes de API
**Archivo**: `lib/core/constants/api_constants.dart`
- Endpoints para interviews (`/api/interviews`)
- Headers (X-API-Key, Content-Type, etc.)
- Parámetros de query (tenant_id, status, limit, offset, etc.)
- Valores por defecto

#### 2. Constantes de Dominio
**Archivo**: `lib/features/interviews/domain/constants/interview_constants.dart`
- Enums: `InterviewType`, `InterviewStatus`, `ProcessingProvider`
- Constantes de tipos: VISITA, CLIENTE
- Constantes de estados: RECEIVED, TRANSCRIBED, EMBEDDED, INDEXED, FAILED
- Métodos helper para estados (isProcessing, isCompleted, hasFailed)

#### 3. Permisos
**Archivo**: `lib/core/constants/permissions.dart`
- Permisos de interviews: READ, CREATE, UPDATE, DELETE
- `PermissionHelper` con métodos:
  - `hasPermission()` - Verifica un permiso específico (soporta wildcards)
  - `hasAllPermissions()` - Verifica múltiples permisos (AND)
  - `hasAnyPermission()` - Verifica múltiples permisos (OR)

#### 4. Manejo de Errores Mejorado

**Excepciones Nuevas** (`lib/core/error/exceptions.dart`):
- `UnauthorizedException` - 401 Unauthorized
- `ForbiddenException` - 403 Forbidden
- `NotFoundException` - 404 Not Found
- `ValidationException` - 400 Bad Request
- `TimeoutException` - 408 Request Timeout
- `ServerException` ahora incluye `statusCode`

**Failures Nuevos** (`lib/core/error/failures.dart`):
- `UnauthorizedFailure`
- `ForbiddenFailure`
- `NotFoundFailure`
- `ValidationFailure`
- `TimeoutFailure`

**HTTP Error Handler** (`lib/core/utils/http_error_handler.dart`):
- `handleResponse()` - Maneja respuestas HTTP y lanza excepciones apropiadas
- `handleException()` - Convierte excepciones generales a excepciones específicas

### Configuración de Entorno

**Variables de entorno** (`.env`):
```
API_URL = https://0kb3vw04uf.execute-api.us-east-1.amazonaws.com/prod/
API_KEY = sk_live_...
```

---

## Fase 2: Capa de Datos (Data Layer) ✅ COMPLETADA

### Modelos Creados

#### 1. InterviewModel
**Archivo**: `lib/features/interviews/data/models/interview_model.dart`
- ✅ Todos los campos según la guía (13 campos)
- ✅ `fromJson()` con parsing de enums y fechas
- ✅ `toJson()` con conversión de enums y fechas
- ✅ `fromEntity()` para convertir desde entidad
- ✅ `copyWith()` para crear copias inmutables

**Campos incluidos**:
- id, tenantId, projectId, advisorId
- interviewType (enum), s3AudioKey, languageCode
- startedAt, endedAt, durationSec
- status (enum), providerUsed (enum)
- createdAt, updatedAt

#### 2. InterviewSegmentModel
**Archivo**: `lib/features/interviews/data/models/interview_segment_model.dart`
- ✅ Modelo para segmentos de transcripción
- ✅ Campos: id, interviewId, segmentIndex, startSec, endSec, text, createdAt
- ✅ Serialización completa

**Entidad correspondiente**: `lib/features/interviews/domain/entities/interview_segment.dart`
- Métodos helper: `formattedTimeRange`, `durationSec`

#### 3. InterviewFiltersModel
**Archivo**: `lib/features/interviews/data/models/interview_filters_model.dart`
- ✅ Manejo de filtros opcionales (tenantId, projectId, advisorId, type, status)
- ✅ Paginación (limit, offset)
- ✅ `toQueryParams()` - Convierte a query string
- ✅ `copyWith()` - Crear copias con modificaciones
- ✅ `clearFilters()` - Limpiar todos los filtros
- ✅ `hasActiveFilters` - Detectar si hay filtros activos
- ✅ `activeFiltersCount` - Contar filtros activos

#### 4. InterviewsResponseModel
**Archivo**: `lib/features/interviews/data/models/interviews_response_model.dart`
- ✅ Modelo de respuesta de la API
- ✅ Lista de interviews + total count
- ✅ `hasMore` - Detectar si hay más páginas

### DataSource Implementado

**Archivo**: `lib/features/interviews/data/datasources/interviews_remote_datasource.dart`

Métodos implementados:
- ✅ `getInterviews(filters)` - GET /api/interviews con query params
- ✅ `getInterviewById(id)` - GET /api/interviews/{id}
- ✅ `createInterview(data)` - POST /api/interviews
- ✅ `updateInterview(id, data)` - PUT /api/interviews/{id}
- ✅ `deleteInterview(id)` - DELETE /api/interviews/{id}

Características:
- ✅ Headers automáticos (X-API-Key, Content-Type)
- ✅ Logging de requests y responses
- ✅ Manejo de errores HTTP con `HttpErrorHandler`
- ✅ Uso de constantes de API

### Repository Implementado

**Interface**: `lib/features/interviews/domain/repositories/interviews_repository.dart`
- ✅ Definición del contrato
- ✅ Retornos con `Either<Failure, Success>`

**Implementación**: `lib/features/interviews/data/repositories/interviews_repository_impl.dart`
- ✅ Todos los métodos implementados
- ✅ Conversión de excepciones a failures
- ✅ Logging detallado de errores
- ✅ Manejo completo de todos los tipos de errores:
  - ServerException → ServerFailure
  - NetworkException → NetworkFailure
  - UnauthorizedException → UnauthorizedFailure
  - ForbiddenException → ForbiddenFailure
  - NotFoundException → NotFoundFailure
  - ValidationException → ValidationFailure
  - TimeoutException → TimeoutFailure

### Entidades Actualizadas

**Interview Entity**: `lib/features/interviews/domain/entities/interview.dart`
- ✅ 14 campos completos según la guía
- ✅ Uso de enums (InterviewType, InterviewStatus, ProcessingProvider)
- ✅ Métodos helper: `isProcessing`, `isCompleted`, `hasFailed`, `formattedDuration`
- ✅ Inmutable con Equatable

---

## Fase 3: Capa de Dominio - Use Cases ✅ COMPLETADA

### Use Cases Implementados

Todos los use cases siguen el patrón `UseCase<Type, Params>` definido en `lib/core/usecases/usecase.dart`.

#### 1. GetInterviews
**Archivo**: `lib/features/interviews/domain/usecases/get_interviews.dart`
- ✅ Obtiene lista de interviews con filtros opcionales
- ✅ Parámetros: `GetInterviewsParams` (contiene `InterviewFiltersModel`)
- ✅ Retorno: `Either<Failure, GetInterviewsResult>`
- ✅ `GetInterviewsResult` incluye lista de interviews y total count
- ✅ Método helper `hasMore` para paginación

**Uso**:
```dart
final usecase = GetInterviews(repository);
final result = await usecase(GetInterviewsParams(
  filters: InterviewFiltersModel(
    tenantId: 'tenant-uuid',
    status: InterviewStatus.indexed,
    limit: 20,
  ),
));
```

#### 2. GetInterviewById
**Archivo**: `lib/features/interviews/domain/usecases/get_interview_by_id.dart`
- ✅ Obtiene una interview específica por ID
- ✅ Parámetros: `GetInterviewByIdParams` (id)
- ✅ Retorno: `Either<Failure, Interview>`

**Uso**:
```dart
final usecase = GetInterviewById(repository);
final result = await usecase(GetInterviewByIdParams(id: 'interview-uuid'));
```

#### 3. CreateInterview
**Archivo**: `lib/features/interviews/domain/usecases/create_interview.dart`
- ✅ Crea una nueva interview en el sistema
- ✅ Parámetros: `CreateInterviewParams`
  - tenantId, projectId, advisorId
  - interviewType (enum)
  - s3AudioKey
  - languageCode (opcional, default: es-PE)
- ✅ Retorno: `Either<Failure, Interview>`
- ✅ Estado inicial automático: RECEIVED

**Uso**:
```dart
final usecase = CreateInterview(repository);
final result = await usecase(CreateInterviewParams(
  tenantId: 'tenant-uuid',
  projectId: 'project-uuid',
  advisorId: 'advisor-uuid',
  interviewType: InterviewType.visita,
  s3AudioKey: 'path/to/audio.m4a',
));
```

#### 4. UpdateInterview
**Archivo**: `lib/features/interviews/domain/usecases/update_interview.dart`
- ✅ Actualiza una interview existente
- ✅ Parámetros: `UpdateInterviewParams`
  - id (requerido)
  - status, providerUsed (opcionales)
  - startedAt, endedAt, durationSec (opcionales)
- ✅ Retorno: `Either<Failure, Interview>`
- ✅ Solo envía los campos que se proporcionan

**Uso**:
```dart
final usecase = UpdateInterview(repository);
final result = await usecase(UpdateInterviewParams(
  id: 'interview-uuid',
  status: InterviewStatus.transcribed,
  providerUsed: ProcessingProvider.gemini,
));
```

#### 5. DeleteInterview
**Archivo**: `lib/features/interviews/domain/usecases/delete_interview.dart`
- ✅ Elimina una interview del sistema
- ✅ Parámetros: `DeleteInterviewParams` (id)
- ✅ Retorno: `Either<Failure, void>`
- ⚠️ **Advertencia**: Elimina en cascada todos los segmentos y tags

**Uso**:
```dart
final usecase = DeleteInterview(repository);
final result = await usecase(DeleteInterviewParams(id: 'interview-uuid'));
```

### Resumen de Use Cases

| Use Case | Propósito | Params | Return |
|----------|-----------|--------|--------|
| GetInterviews | Listar con filtros | InterviewFiltersModel | List + total |
| GetInterviewById | Obtener por ID | String id | Interview |
| CreateInterview | Crear nueva | tenant, project, advisor, type, s3Key | Interview |
| UpdateInterview | Actualizar existente | id + campos opcionales | Interview |
| DeleteInterview | Eliminar | String id | void |

---

## Fase 4: Capa de Presentación (BLoC + UI) ✅ COMPLETADA

### BLoCs Implementados

#### 1. InterviewsBloc
**Archivos**:
- `lib/features/interviews/presentation/bloc/interviews_bloc.dart`
- `lib/features/interviews/presentation/bloc/interviews_event.dart`
- `lib/features/interviews/presentation/bloc/interviews_state.dart`

**Eventos**:
- ✅ `LoadInterviews` - Cargar interviews de un proyecto
- ✅ `RefreshInterviews` - Refrescar lista
- ✅ `LoadMoreInterviews` - Paginación infinita
- ✅ `FilterByType` - Filtrar por tipo (VISITA/CLIENTE)
- ✅ `FilterByStatus` - Filtrar por estado
- ✅ `ClearFilters` - Limpiar todos los filtros

**Estados**:
- ✅ `InterviewsInitial` - Estado inicial
- ✅ `InterviewsLoading` - Cargando datos
- ✅ `InterviewsLoaded` - Datos cargados (con paginación)
- ✅ `InterviewsEmpty` - Sin resultados
- ✅ `InterviewsError` - Error con mensaje

**Características**:
- ✅ Manejo de filtros (tipo, estado)
- ✅ Paginación infinita (load more)
- ✅ Pull-to-refresh
- ✅ Detección de filtros activos

#### 2. InterviewDetailBloc
**Archivos**:
- `lib/features/interviews/presentation/bloc/interview_detail_bloc.dart`
- `lib/features/interviews/presentation/bloc/interview_detail_event.dart`
- `lib/features/interviews/presentation/bloc/interview_detail_state.dart`

**Eventos**:
- ✅ `LoadInterviewDetail` - Cargar detalle por ID
- ✅ `RefreshInterviewDetail` - Refrescar detalle
- ✅ `DeleteInterviewEvent` - Eliminar interview

**Estados**:
- ✅ `InterviewDetailInitial` - Estado inicial
- ✅ `InterviewDetailLoading` - Cargando detalle
- ✅ `InterviewDetailLoaded` - Detalle cargado
- ✅ `InterviewDetailDeleting` - Eliminando
- ✅ `InterviewDetailDeleted` - Eliminado exitosamente
- ✅ `InterviewDetailError` - Error con mensaje

**Características**:
- ✅ Carga de detalle por ID
- ✅ Refresh manual
- ✅ Eliminación con confirmación
- ✅ Manejo de errores manteniendo datos

---

### Widgets Reutilizables

#### 1. InterviewStatusBadge
**Archivo**: `lib/features/interviews/presentation/widgets/interview_status_badge.dart`

- ✅ Badge con colores por estado
- ✅ Íconos opcionales
- ✅ Estados:
  - RECEIVED (Gris)
  - TRANSCRIBED (Azul)
  - EMBEDDED (Naranja)
  - INDEXED (Verde)
  - FAILED (Rojo)

#### 2. InterviewCard
**Archivo**: `lib/features/interviews/presentation/widgets/interview_card.dart`

- ✅ Card para mostrar interview en lista
- ✅ Tipo e ícono (VISITA/CLIENTE)
- ✅ Badge de estado
- ✅ Duración y fecha
- ✅ Proveedor de procesamiento
- ✅ Indicador de progreso para interviews en proceso
- ✅ Formato de fecha relativo (Hoy, Ayer, X días atrás)

#### 3. EmptyInterviewsWidget
**Archivo**: `lib/features/interviews/presentation/widgets/empty_interviews_widget.dart`

- ✅ Estado vacío con mensaje
- ✅ Diferentes mensajes según contexto (sin datos vs filtros sin resultados)
- ✅ Botón para limpiar filtros

---

### Páginas (UI)

#### 1. InterviewsListPage
**Archivo**: `lib/features/interviews/presentation/pages/interviews_list_page.dart`

**Parámetros requeridos**:
- `projectId` - ID del proyecto
- `projectName` - Nombre del proyecto (para mostrar)
- `tenantId` - ID del tenant

**Características**:
- ✅ Lista de interviews del proyecto
- ✅ Pull-to-refresh
- ✅ Paginación infinita (scroll)
- ✅ Filtros por tipo y estado
- ✅ Chips de filtro con indicadores activos
- ✅ Contador de filtros activos
- ✅ Botón limpiar filtros
- ✅ Estados: loading, loaded, empty, error
- ✅ Navegación a detalle al hacer tap

**Uso desde ProjectsPage**:
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => BlocProvider(
      create: (context) => sl<InterviewsBloc>()
        ..add(LoadInterviews(
          projectId: project.id,
          tenantId: tenantId,
        )),
      child: InterviewsListPage(
        projectId: project.id,
        projectName: project.name,
        tenantId: tenantId,
      ),
    ),
  ),
);
```

#### 2. InterviewDetailPage
**Archivo**: `lib/features/interviews/presentation/pages/interview_detail_page.dart`

**Parámetros requeridos**:
- `interviewId` - ID de la interview

**Características**:
- ✅ Detalle completo de interview
- ✅ Timeline de procesamiento visual
- ✅ Información detallada (duración, fechas, proveedor)
- ✅ Archivo de audio (s3 key)
- ✅ IDs de referencia (interview, tenant, project, advisor)
- ✅ Pull-to-refresh
- ✅ Menú de opciones (actualizar, eliminar)
- ✅ Confirmación antes de eliminar
- ✅ Navegación automática después de eliminar
- ✅ Estados de carga y error

**Uso desde InterviewCard**:
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => InterviewDetailPage(
      interviewId: interview.id,
    ),
  ),
);
```

---

### Flujo de Integración

#### 1. Desde ProjectsPage → Ver Entrevistas

En `ProjectsPage`, agregar botón para ver interviews:

```dart
CustomOutlineButton(
  text: 'VER ENTREVISTAS',
  icon: Icon(Icons.list),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => sl<InterviewsBloc>()
            ..add(LoadInterviews(
              projectId: selectedProject.id,
              tenantId: currentTenantId,
            )),
          child: InterviewsListPage(
            projectId: selectedProject.id,
            projectName: selectedProject.name,
            tenantId: currentTenantId,
          ),
        ),
      ),
    );
  },
)
```

#### 2. Después de Grabar Audio → Crear Interview

En `RecordUploadBloc`, después de `RecordUploadSuccess`, crear interview:

```dart
// En RecordUploadSuccess state
if (state is RecordUploadSuccess) {
  // Crear interview usando el use case
  final createResult = await createInterview(CreateInterviewParams(
    tenantId: tenantId,
    projectId: projectId,
    advisorId: currentAdvisorId,
    interviewType: InterviewType.visita, // o CLIENTE según contexto
    s3AudioKey: state.s3Key,
  ));

  // Navegar a la lista de interviews o mostrar mensaje de éxito
}
```

---

### Próximos Pasos

**Configuración pendiente**:
1. ✅ Agregar `InterviewsBloc` y `InterviewDetailBloc` al `injection_container.dart`
2. ✅ Agregar dependencias de paquetes si faltan (`intl` para formateo de fechas)
3. ✅ Integrar creación de interview después de subir audio
4. ✅ Agregar botón "Ver Entrevistas" en ProjectsPage
5. ⏳ Testing (unit tests, widget tests)

**Mejoras opcionales**:
- Polling automático para interviews en proceso
- Notificaciones cuando cambie de estado
- Ver/reproducir audio
- Ver transcripción por segmentos
- Analytics/estadísticas de interviews
