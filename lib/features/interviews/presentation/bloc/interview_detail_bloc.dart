import 'package:booster/core/error/failures.dart';
import 'package:booster/features/interviews/domain/usecases/delete_interview.dart';
import 'package:booster/features/interviews/domain/usecases/get_interview_by_id.dart';
import 'package:booster/features/interviews/presentation/bloc/interview_detail_event.dart';
import 'package:booster/features/interviews/presentation/bloc/interview_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// BLoC for managing interview detail
class InterviewDetailBloc extends Bloc<InterviewDetailEvent, InterviewDetailState> {
  final GetInterviewById getInterviewById;
  final DeleteInterview deleteInterview;

  String? _currentInterviewId;

  InterviewDetailBloc({
    required this.getInterviewById,
    required this.deleteInterview,
  }) : super(const InterviewDetailInitial()) {
    on<LoadInterviewDetail>(_onLoadInterviewDetail);
    on<RefreshInterviewDetail>(_onRefreshInterviewDetail);
    on<DeleteInterviewEvent>(_onDeleteInterview);
  }

  Future<void> _onLoadInterviewDetail(
    LoadInterviewDetail event,
    Emitter<InterviewDetailState> emit,
  ) async {
    _currentInterviewId = event.interviewId;
    emit(const InterviewDetailLoading());

    final result = await getInterviewById(
      GetInterviewByIdParams(id: event.interviewId),
    );

    result.fold(
      (failure) => emit(InterviewDetailError(_mapFailureToMessage(failure))),
      (interview) => emit(InterviewDetailLoaded(interview)),
    );
  }

  Future<void> _onRefreshInterviewDetail(
    RefreshInterviewDetail event,
    Emitter<InterviewDetailState> emit,
  ) async {
    if (_currentInterviewId == null) return;

    // Keep current state while refreshing
    final currentState = state;

    final result = await getInterviewById(
      GetInterviewByIdParams(id: _currentInterviewId!),
    );

    result.fold(
      (failure) {
        // If refresh fails, show error but keep current data if available
        if (currentState is InterviewDetailLoaded) {
          emit(InterviewDetailError(
            _mapFailureToMessage(failure),
            interview: currentState.interview,
          ));
        } else {
          emit(InterviewDetailError(_mapFailureToMessage(failure)));
        }
      },
      (interview) => emit(InterviewDetailLoaded(interview)),
    );
  }

  Future<void> _onDeleteInterview(
    DeleteInterviewEvent event,
    Emitter<InterviewDetailState> emit,
  ) async {
    final currentState = state;
    if (currentState is InterviewDetailLoaded) {
      emit(InterviewDetailDeleting(currentState.interview));
    }

    final result = await deleteInterview(
      DeleteInterviewParams(id: event.interviewId),
    );

    result.fold(
      (failure) {
        if (currentState is InterviewDetailLoaded) {
          emit(InterviewDetailError(
            _mapFailureToMessage(failure),
            interview: currentState.interview,
          ));
        } else {
          emit(InterviewDetailError(_mapFailureToMessage(failure)));
        }
      },
      (_) {
        _currentInterviewId = null;
        emit(const InterviewDetailDeleted());
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'No hay conexión a internet';
    } else if (failure is UnauthorizedFailure) {
      return 'No autorizado. Por favor inicia sesión nuevamente';
    } else if (failure is ForbiddenFailure) {
      return 'No tienes permisos para realizar esta acción';
    } else if (failure is NotFoundFailure) {
      return 'Entrevista no encontrada';
    } else if (failure is ServerFailure) {
      return 'Error del servidor: ${failure.message}';
    }
    return failure.message;
  }
}
