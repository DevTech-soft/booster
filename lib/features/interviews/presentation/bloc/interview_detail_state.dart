import 'package:booster/features/interviews/domain/entities/interview.dart';
import 'package:equatable/equatable.dart';

/// States for InterviewDetailBloc
sealed class InterviewDetailState extends Equatable {
  const InterviewDetailState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class InterviewDetailInitial extends InterviewDetailState {
  const InterviewDetailInitial();
}

/// Loading state
class InterviewDetailLoading extends InterviewDetailState {
  const InterviewDetailLoading();
}

/// Loaded state with interview data
class InterviewDetailLoaded extends InterviewDetailState {
  final Interview interview;

  const InterviewDetailLoaded(this.interview);

  @override
  List<Object?> get props => [interview];
}

/// Deleting state
class InterviewDetailDeleting extends InterviewDetailState {
  final Interview interview;

  const InterviewDetailDeleting(this.interview);

  @override
  List<Object?> get props => [interview];
}

/// Deleted state
class InterviewDetailDeleted extends InterviewDetailState {
  const InterviewDetailDeleted();
}

/// Error state
class InterviewDetailError extends InterviewDetailState {
  final String message;
  final Interview? interview; // Keep interview data if available

  const InterviewDetailError(this.message, {this.interview});

  @override
  List<Object?> get props => [message, interview];
}
