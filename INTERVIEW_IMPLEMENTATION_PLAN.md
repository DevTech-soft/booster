# Plan de Implementación - Interviews Feature

## Estado: 📋 Planificación
**Fecha de creación**: 2026-01-07
**Basado en**: INTERVIEW_GUIDE.txt

---

## 🎯 Objetivo

Implementar la funcionalidad de **Interviews (Entrevistas)** en la aplicación Flutter, permitiendo:
- Listar entrevistas de un tenant/proyecto/advisor
- Ver detalles de una entrevista específica
- Crear nuevas entrevistas (trigger del audio)
- Monitorear el estado de procesamiento
- Filtrar por tipo, estado, fechas, etc.

---

## 📊 Contexto del Backend

### Estados de una Interview
```
RECEIVED → TRANSCRIBED → EMBEDDED → INDEXED
                                    ↓
                                  FAILED
```

### Tipos de Interviews
- **VISITA**: Visitas inmobiliarias (3 fases: SALA, RECORRIDO, POST-SALA)
- **CLIENTE**: Entrevistas con clientes (sin fases)

### Estructura de Datos Principal
```json
{
  "id": "uuid",
  "tenant_id": "uuid",
  "project_id": "uuid",
  "advisor_id": "uuid",
  "interview_type": "VISITA | CLIENTE",
  "s3_audio_key": "path/to/audio.m4a",
  "language_code": "es-PE",
  "started_at": "timestamp",
  "ended_at": "timestamp",
  "duration_sec": 2700,
  "status": "INDEXED",
  "provider_used": "GEMINI | TRANSCRIBE",
  "created_at": "timestamp",
  "updated_at": "timestamp"
}
```

---

## 🏗️ Arquitectura de Implementación (Clean Architecture)

```
lib/features/interviews/
├── data/
│   ├── models/
│   │   ├── interview_model.dart
│   │   ├── interview_segment_model.dart
│   │   └── interview_filters_model.dart
│   ├── datasources/
│   │   ├── interviews_remote_datasource.dart
│   │   └── interviews_local_datasource.dart (opcional - cache)
│   └── repositories/
│       └── interviews_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── interview.dart
│   │   ├── interview_segment.dart
│   │   └── interview_filters.dart
│   ├── repositories/
│   │   └── interviews_repository.dart
│   └── usecases/
│       ├── get_interviews.dart
│       ├── get_interview_details.dart
│       ├── create_interview.dart
│       ├── update_interview.dart
│       └── delete_interview.dart
└── presentation/
    ├── bloc/
    │   ├── interviews_bloc.dart
    │   ├── interviews_event.dart
    │   ├── interviews_state.dart
    │   ├── interview_detail_bloc.dart
    │   └── interview_filters_bloc.dart
    ├── pages/
    │   ├── interviews_list_page.dart
    │   └── interview_detail_page.dart
    └── widgets/
        ├── interview_card.dart
        ├── interview_status_badge.dart
        ├── interview_filters_sheet.dart
        └── interview_timeline_widget.dart
```

---

## 🔌 Endpoints de API a Consumir

### Base URL
```
https://your-api-endpoint.com/api
```

### Endpoints
| Método | Endpoint | Descripción |
|--------|----------|-------------|
| `GET` | `/interviews` | Listar interviews con filtros |
| `GET` | `/interviews/{id}` | Obtener interview específica |
| `POST` | `/interviews` | Crear nueva interview |
| `PUT` | `/interviews/{id}` | Actualizar interview |
| `DELETE` | `/interviews/{id}` | Eliminar interview |

### Parámetros de Query para GET /interviews
- `tenant_id` (requerido): UUID del tenant
- `project_id` (opcional): Filtrar por proyecto
- `advisor_id` (opcional): Filtrar por advisor
- `interview_type` (opcional): VISITA | CLIENTE
- `status` (opcional): RECEIVED | TRANSCRIBED | EMBEDDED | INDEXED | FAILED
- `limit` (opcional): Número de resultados (default: 50)
- `offset` (opcional): Para paginación (default: 0)

### Headers Requeridos
```
X-API-Key: sk_live_...
Content-Type: application/json
```

---

## ✅ Checklist de Implementación

### Fase 1: Configuración Base ⏳
- [ ] Crear estructura de carpetas según Clean Architecture
- [ ] Configurar constantes de API (endpoints, headers)
- [ ] Agregar permisos necesarios (INTERVIEW_*)
- [ ] Configurar manejo de errores específicos

### Fase 2: Capa de Datos (Data Layer) 📦
- [ ] **Models**
  - [ ] `InterviewModel` con fromJson/toJson
  - [ ] `InterviewSegmentModel` con fromJson/toJson
  - [ ] `InterviewFiltersModel` para filtros de búsqueda
  - [ ] Enums: `InterviewType`, `InterviewStatus`, `ProcessingProvider`

- [ ] **Remote DataSource**
  - [ ] `getInterviews()` con filtros y paginación
  - [ ] `getInterviewById(id)`
  - [ ] `createInterview(data)`
  - [ ] `updateInterview(id, data)`
  - [ ] `deleteInterview(id)`
  - [ ] Manejo de autenticación (API Key)
  - [ ] Manejo de errores HTTP

- [ ] **Local DataSource** (opcional)
  - [ ] Cache con Hive/SharedPreferences
  - [ ] Estrategia de invalidación de cache

- [ ] **Repository Implementation**
  - [ ] Implementar interfaz del domain
  - [ ] Manejo de excepciones
  - [ ] Logging

### Fase 3: Capa de Dominio (Domain Layer) 🎯
- [ ] **Entities**
  - [ ] `Interview` entity (inmutable)
  - [ ] `InterviewSegment` entity
  - [ ] `InterviewFilters` value object

- [ ] **Repository Interface**
  - [ ] Definir contrato abstracto
  - [ ] Tipos de retorno con Either<Failure, Success>

- [ ] **Use Cases**
  - [ ] `GetInterviews` con filtros
  - [ ] `GetInterviewDetails`
  - [ ] `CreateInterview`
  - [ ] `UpdateInterview`
  - [ ] `DeleteInterview`
  - [ ] `FilterInterviews` (opcional)

### Fase 4: Capa de Presentación (Presentation Layer) 🎨
- [ ] **BLoC/Cubit**
  - [ ] `InterviewsBloc` para lista
    - [ ] Events: LoadInterviews, RefreshInterviews, FilterInterviews, LoadMoreInterviews
    - [ ] States: Initial, Loading, Loaded, Error, Empty
  - [ ] `InterviewDetailBloc` para detalle
    - [ ] Events: LoadInterviewDetail, UpdateInterview
    - [ ] States: Loading, Loaded, Error
  - [ ] `InterviewFiltersBloc` para filtros
    - [ ] States: filtros activos, count de resultados

- [ ] **Pages**
  - [ ] `InterviewsListPage`
    - [ ] AppBar con título y acciones
    - [ ] ListView con pull-to-refresh
    - [ ] Infinite scroll (paginación)
    - [ ] Botón flotante para crear (si aplica)
    - [ ] Bottom sheet de filtros
  - [ ] `InterviewDetailPage`
    - [ ] Hero animation con card
    - [ ] Timeline de estados
    - [ ] Información completa
    - [ ] Botones de acción (editar, eliminar)

- [ ] **Widgets Reutilizables**
  - [ ] `InterviewCard`
    - [ ] Badge de tipo (VISITA/CLIENTE)
    - [ ] Badge de estado con color
    - [ ] Info de advisor, proyecto, fechas
    - [ ] Progress indicator si está procesando
  - [ ] `InterviewStatusBadge` con colores por estado:
    - [ ] RECEIVED: grey
    - [ ] TRANSCRIBED: blue
    - [ ] EMBEDDED: orange
    - [ ] INDEXED: green
    - [ ] FAILED: red
  - [ ] `InterviewFiltersSheet`
    - [ ] Filtro por tipo
    - [ ] Filtro por estado
    - [ ] Filtro por proyecto (dropdown)
    - [ ] Filtro por advisor (dropdown)
    - [ ] Filtro por fechas (date picker)
    - [ ] Botón "Aplicar" y "Limpiar"
  - [ ] `InterviewTimelineWidget`
    - [ ] Timeline visual del procesamiento
    - [ ] Estados completados vs pendientes

### Fase 5: Integración y Testing 🧪
- [ ] **Unit Tests**
  - [ ] Models: fromJson/toJson
  - [ ] Use cases con mocks
  - [ ] Repository con mocks

- [ ] **Widget Tests**
  - [ ] InterviewCard rendering
  - [ ] InterviewStatusBadge
  - [ ] Páginas completas

- [ ] **Integration Tests**
  - [ ] Flujo completo: lista → detalle
  - [ ] Filtros y búsqueda
  - [ ] Refresh y paginación

- [ ] **Manual Testing**
  - [ ] Pruebas con API real
  - [ ] Casos de error (network, 404, 500)
  - [ ] Estados vacíos
  - [ ] Performance con muchos items

### Fase 6: UI/UX Refinamiento 🎨
- [ ] Shimmer loading states
- [ ] Empty states con ilustraciones
- [ ] Error states con retry
- [ ] Animaciones smooth
- [ ] Responsive design (tablet)
- [ ] Dark mode support
- [ ] Accessibility (semantics)

### Fase 7: Features Adicionales (Opcional) 🚀
- [ ] Búsqueda por texto en interviews
- [ ] Ordenamiento (fecha, duración, tipo)
- [ ] Exportar lista a CSV/PDF
- [ ] Notificaciones push cuando estado cambia
- [ ] Reproductor de audio integrado
- [ ] Ver segmentos de transcripción
- [ ] Tags visuales de segmentos
- [ ] Analytics/Dashboard de interviews

---

## 🎨 Propuesta de UI

### Lista de Interviews
```
┌─────────────────────────────────────┐
│  Entrevistas          [Filter]  [+] │
├─────────────────────────────────────┤
│ ┌─────────────────────────────────┐ │
│ │ 🎤 VISITA          ● INDEXED    │ │
│ │ Proyecto Alpha                   │ │
│ │ Advisor: Juan Pérez             │ │
│ │ 45 min • 01 Ene 2024            │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ 👥 CLIENTE         ⏳ TRANSCRIBED│ │
│ │ Proyecto Beta                    │ │
│ │ Advisor: María López            │ │
│ │ 30 min • 31 Dic 2023            │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

### Detalle de Interview
```
┌─────────────────────────────────────┐
│  ← Detalle de Entrevista            │
├─────────────────────────────────────┤
│                                     │
│  🎤 VISITA                          │
│  ● INDEXED                          │
│                                     │
│  Timeline de Procesamiento          │
│  ✓ RECEIVED    → ✓ TRANSCRIBED     │
│  ✓ EMBEDDED    → ✓ INDEXED         │
│                                     │
│  Información                        │
│  Proyecto: Alpha                    │
│  Advisor: Juan Pérez                │
│  Duración: 45 min                   │
│  Idioma: es-PE                      │
│  Proveedor: GEMINI                  │
│                                     │
│  Inicio: 01 Ene 2024 10:00         │
│  Fin: 01 Ene 2024 10:45            │
│                                     │
│  Archivo:                           │
│  tenant/audio/visitas/...m4a        │
│                                     │
│  [Ver Transcripción] [Eliminar]    │
│                                     │
└─────────────────────────────────────┘
```

---

## 🔐 Permisos Necesarios

Asegurarse de que el rol del usuario tenga:
```dart
const interviewPermissions = [
  'INTERVIEW_READ',    // Para listar y ver detalles
  'INTERVIEW_CREATE',  // Para crear (si aplica)
  'INTERVIEW_UPDATE',  // Para actualizar (si aplica)
  'INTERVIEW_DELETE',  // Para eliminar (si aplica)
];
```

O usar wildcard:
```dart
const interviewPermissions = ['INTERVIEW_*'];
```

---

## 🚨 Casos de Error a Manejar

1. **Network Error**: Sin conexión a internet
2. **401 Unauthorized**: API Key inválida o expirada
3. **403 Forbidden**: Sin permisos para la operación
4. **404 Not Found**: Interview no encontrada
5. **500 Server Error**: Error en el backend
6. **Timeout**: Request muy lento
7. **Empty State**: No hay interviews para mostrar
8. **Failed Interviews**: Mostrar estado FAILED con opción de reintentar

---

## 📝 Notas de Implementación

### Estrategia de Cache
- Cache local de 5 minutos para lista
- Invalidar cache al crear/actualizar/eliminar
- Pull-to-refresh invalida cache manualmente

### Paginación
- Usar `limit=20` y `offset` incremental
- Infinite scroll cuando llegue al 80% de la lista
- Mostrar loading indicator al cargar más

### Filtros
- Guardar filtros activos en estado local
- Persistir filtros favoritos en SharedPreferences
- Botón para limpiar todos los filtros

### Estados de Procesamiento
- Polling cada 5-10 segundos para interviews en proceso
- Stop polling cuando llegue a INDEXED o FAILED
- Notificación cuando cambie de estado

### Manejo de Fechas
- Usar `intl` package para formateo
- Mostrar fechas relativas (hace 2 horas, ayer, etc.)
- Timezone del usuario

---

## 🔗 Referencias

- **Guía Original**: `lib/INTERVIEW_GUIDE.txt`
- **Patrón Similar**: Ver implementación de `records` feature
- **API Docs**: (agregar URL cuando esté disponible)

---

## 📅 Próximos Pasos

1. ✅ Leer y entender INTERVIEW_GUIDE.txt
2. ⏳ Revisar este plan con el equipo
3. ⏳ Priorizar fases de implementación
4. ⏳ Comenzar con Fase 1: Configuración Base
5. ⏳ Iterar fase por fase

---

## 🤔 Preguntas Pendientes

- [ ] ¿Se necesita crear interviews desde la app o solo listar?
- [ ] ¿Hay que implementar subida de audio o se hace desde otro lugar?
- [ ] ¿Qué nivel de detalle mostrar en los segmentos?
- [ ] ¿Se requiere búsqueda de texto dentro de transcripciones?
- [ ] ¿Hay dashboards/analytics de interviews?
- [ ] ¿Los advisors pueden ver solo sus interviews o todas?
- [ ] ¿Se requiere filtrar por rango de fechas?

---

**Estado del Documento**: 📋 Borrador Inicial
**Última Actualización**: 2026-01-07
**Autor**: Claude Code Assistant
