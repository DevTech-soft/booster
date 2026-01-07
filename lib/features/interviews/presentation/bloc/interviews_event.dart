import 'package:booster/features/interviews/data/models/interview_filters_model.dart';
import 'package:booster/features/interviews/domain/constants/interview_constants.dart';
import 'package:equatable/equatable.dart';

/// Events for InterviewsBloc
sealed class InterviewsEvent extends Equatable {
  const InterviewsEvent();

  @override
  List<Object?> get props => [];
}

/// Load interviews for a specific project
class LoadInterviews extends InterviewsEvent {
  final String projectId;
  final String tenantId;
  final InterviewType? interviewType;
  final InterviewStatus? status;

  const LoadInterviews({
    required this.projectId,
    required this.tenantId,
    this.interviewType,
    this.status,
  });

  @override
  List<Object?> get props => [projectId, tenantId, interviewType, status];
}

/// Refresh interviews list
class RefreshInterviews extends InterviewsEvent {
  const RefreshInterviews();
}

/// Load more interviews (pagination)
class LoadMoreInterviews extends InterviewsEvent {
  const LoadMoreInterviews();
}

/// Filter interviews by type
class FilterByType extends InterviewsEvent {
  final InterviewType? interviewType;

  const FilterByType(this.interviewType);

  @override
  List<Object?> get props => [interviewType];
}

/// Filter interviews by status
class FilterByStatus extends InterviewsEvent {
  final InterviewStatus? status;

  const FilterByStatus(this.status);

  @override
  List<Object?> get props => [status];
}

/// Clear all filters
class ClearFilters extends InterviewsEvent {
  const ClearFilters();
}
