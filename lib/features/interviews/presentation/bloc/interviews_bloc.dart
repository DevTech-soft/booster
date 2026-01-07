import 'package:booster/core/error/failures.dart';
import 'package:booster/features/interviews/data/models/interview_filters_model.dart';
import 'package:booster/features/interviews/domain/usecases/get_interviews.dart';
import 'package:booster/features/interviews/presentation/bloc/interviews_event.dart';
import 'package:booster/features/interviews/presentation/bloc/interviews_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// BLoC for managing interviews list
class InterviewsBloc extends Bloc<InterviewsEvent, InterviewsState> {
  final GetInterviews getInterviews;

  InterviewsBloc({required this.getInterviews}) : super(const InterviewsInitial()) {
    on<LoadInterviews>(_onLoadInterviews);
    on<RefreshInterviews>(_onRefreshInterviews);
    on<LoadMoreInterviews>(_onLoadMoreInterviews);
    on<FilterByType>(_onFilterByType);
    on<FilterByStatus>(_onFilterByStatus);
    on<ClearFilters>(_onClearFilters);
  }

  Future<void> _onLoadInterviews(
    LoadInterviews event,
    Emitter<InterviewsState> emit,
  ) async {
    emit(const InterviewsLoading());

    final filters = InterviewFiltersModel(
      tenantId: event.tenantId,
      projectId: event.projectId,
      interviewType: event.interviewType,
      status: event.status,
    );

    final result = await getInterviews(GetInterviewsParams(filters: filters));

    result.fold(
      (failure) => emit(InterviewsError(_mapFailureToMessage(failure))),
      (data) {
        if (data.interviews.isEmpty) {
          emit(InterviewsEmpty(filters: filters));
        } else {
          emit(InterviewsLoaded(
            interviews: data.interviews,
            total: data.total,
            filters: filters,
            hasMore: data.hasMore,
          ));
        }
      },
    );
  }

  Future<void> _onRefreshInterviews(
    RefreshInterviews event,
    Emitter<InterviewsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! InterviewsLoaded) return;

    // Reset offset to 0 for refresh
    final filters = currentState.filters.copyWith(offset: 0);

    final result = await getInterviews(GetInterviewsParams(filters: filters));

    result.fold(
      (failure) => emit(InterviewsError(_mapFailureToMessage(failure))),
      (data) {
        if (data.interviews.isEmpty) {
          emit(InterviewsEmpty(filters: filters));
        } else {
          emit(InterviewsLoaded(
            interviews: data.interviews,
            total: data.total,
            filters: filters,
            hasMore: data.hasMore,
          ));
        }
      },
    );
  }

  Future<void> _onLoadMoreInterviews(
    LoadMoreInterviews event,
    Emitter<InterviewsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! InterviewsLoaded) return;
    if (!currentState.hasMore || currentState.isLoadingMore) return;

    // Set loading more flag
    emit(currentState.copyWith(isLoadingMore: true));

    // Increment offset
    final newOffset = currentState.interviews.length;
    final filters = currentState.filters.copyWith(offset: newOffset);

    final result = await getInterviews(GetInterviewsParams(filters: filters));

    result.fold(
      (failure) {
        // Keep current data on error, just stop loading
        emit(currentState.copyWith(isLoadingMore: false));
      },
      (data) {
        final updatedInterviews = [
          ...currentState.interviews,
          ...data.interviews,
        ];

        emit(InterviewsLoaded(
          interviews: updatedInterviews,
          total: data.total,
          filters: filters,
          hasMore: data.hasMore,
          isLoadingMore: false,
        ));
      },
    );
  }

  Future<void> _onFilterByType(
    FilterByType event,
    Emitter<InterviewsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! InterviewsLoaded) return;

    emit(const InterviewsLoading());

    final filters = currentState.filters.copyWith(
      interviewType: event.interviewType,
      offset: 0, // Reset pagination
    );

    final result = await getInterviews(GetInterviewsParams(filters: filters));

    result.fold(
      (failure) => emit(InterviewsError(_mapFailureToMessage(failure))),
      (data) {
        if (data.interviews.isEmpty) {
          emit(InterviewsEmpty(filters: filters));
        } else {
          emit(InterviewsLoaded(
            interviews: data.interviews,
            total: data.total,
            filters: filters,
            hasMore: data.hasMore,
          ));
        }
      },
    );
  }

  Future<void> _onFilterByStatus(
    FilterByStatus event,
    Emitter<InterviewsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! InterviewsLoaded) return;

    emit(const InterviewsLoading());

    final filters = currentState.filters.copyWith(
      status: event.status,
      offset: 0, // Reset pagination
    );

    final result = await getInterviews(GetInterviewsParams(filters: filters));

    result.fold(
      (failure) => emit(InterviewsError(_mapFailureToMessage(failure))),
      (data) {
        if (data.interviews.isEmpty) {
          emit(InterviewsEmpty(filters: filters));
        } else {
          emit(InterviewsLoaded(
            interviews: data.interviews,
            total: data.total,
            filters: filters,
            hasMore: data.hasMore,
          ));
        }
      },
    );
  }

  Future<void> _onClearFilters(
    ClearFilters event,
    Emitter<InterviewsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! InterviewsLoaded && currentState is! InterviewsEmpty) {
      return;
    }

    emit(const InterviewsLoading());

    final currentFilters = currentState is InterviewsLoaded
        ? currentState.filters
        : (currentState as InterviewsEmpty).filters;

    final filters = currentFilters.clearFilters(
      tenantId: currentFilters.tenantId!,
    ).copyWith(
      projectId: currentFilters.projectId, // Keep projectId
    );

    final result = await getInterviews(GetInterviewsParams(filters: filters));

    result.fold(
      (failure) => emit(InterviewsError(_mapFailureToMessage(failure))),
      (data) {
        if (data.interviews.isEmpty) {
          emit(InterviewsEmpty(filters: filters));
        } else {
          emit(InterviewsLoaded(
            interviews: data.interviews,
            total: data.total,
            filters: filters,
            hasMore: data.hasMore,
          ));
        }
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'No hay conexión a internet';
    } else if (failure is UnauthorizedFailure) {
      return 'No autorizado. Por favor inicia sesión nuevamente';
    } else if (failure is ForbiddenFailure) {
      return 'No tienes permisos para ver las entrevistas';
    } else if (failure is NotFoundFailure) {
      return 'Entrevistas no encontradas';
    } else if (failure is ServerFailure) {
      return 'Error del servidor: ${failure.message}';
    }
    return failure.message;
  }
}
