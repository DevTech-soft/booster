import 'package:equatable/equatable.dart';

/// Events for InterviewDetailBloc
sealed class InterviewDetailEvent extends Equatable {
  const InterviewDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Load interview details by ID
class LoadInterviewDetail extends InterviewDetailEvent {
  final String interviewId;

  const LoadInterviewDetail(this.interviewId);

  @override
  List<Object?> get props => [interviewId];
}

/// Refresh interview details
class RefreshInterviewDetail extends InterviewDetailEvent {
  const RefreshInterviewDetail();
}

/// Delete interview
class DeleteInterviewEvent extends InterviewDetailEvent {
  final String interviewId;

  const DeleteInterviewEvent(this.interviewId);

  @override
  List<Object?> get props => [interviewId];
}
