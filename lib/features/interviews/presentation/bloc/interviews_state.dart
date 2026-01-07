import 'package:booster/features/interviews/data/models/interview_filters_model.dart';
import 'package:booster/features/interviews/domain/entities/interview.dart';
import 'package:equatable/equatable.dart';

/// States for InterviewsBloc
sealed class InterviewsState extends Equatable {
  const InterviewsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class InterviewsInitial extends InterviewsState {
  const InterviewsInitial();
}

/// Loading state (first load)
class InterviewsLoading extends InterviewsState {
  const InterviewsLoading();
}

/// Loaded state with data
class InterviewsLoaded extends InterviewsState {
  final List<Interview> interviews;
  final int total;
  final InterviewFiltersModel filters;
  final bool hasMore;
  final bool isLoadingMore;

  const InterviewsLoaded({
    required this.interviews,
    required this.total,
    required this.filters,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [
        interviews,
        total,
        filters,
        hasMore,
        isLoadingMore,
      ];

  InterviewsLoaded copyWith({
    List<Interview>? interviews,
    int? total,
    InterviewFiltersModel? filters,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return InterviewsLoaded(
      interviews: interviews ?? this.interviews,
      total: total ?? this.total,
      filters: filters ?? this.filters,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

/// Empty state (no interviews found)
class InterviewsEmpty extends InterviewsState {
  final InterviewFiltersModel filters;

  const InterviewsEmpty({required this.filters});

  @override
  List<Object?> get props => [filters];
}

/// Error state
class InterviewsError extends InterviewsState {
  final String message;

  const InterviewsError(this.message);

  @override
  List<Object?> get props => [message];
}
