import 'package:booster/core/constants/api_constants.dart';
import 'package:booster/features/interviews/domain/constants/interview_constants.dart';
import 'package:equatable/equatable.dart';

/// Interview Filters Model
/// Contains filters for querying interviews from the API
class InterviewFiltersModel extends Equatable {
  final String? tenantId;
  final String? projectId;
  final String? advisorId;
  final InterviewType? interviewType;
  final InterviewStatus? status;
  final int limit;
  final int offset;

  const InterviewFiltersModel({
    this.tenantId,
    this.projectId,
    this.advisorId,
    this.interviewType,
    this.status,
    this.limit = ApiConstants.defaultLimit,
    this.offset = ApiConstants.defaultOffset,
  });

  @override
  List<Object?> get props => [
        tenantId,
        projectId,
        advisorId,
        interviewType,
        status,
        limit,
        offset,
      ];

  /// Convert filters to query parameters map
  Map<String, String> toQueryParams() {
    final params = <String, String>{};

    if (tenantId != null) {
      params[ApiConstants.tenantIdParam] = tenantId!;
    }
    if (projectId != null) {
      params[ApiConstants.projectIdParam] = projectId!;
    }
    if (advisorId != null) {
      params[ApiConstants.advisorIdParam] = advisorId!;
    }
    if (interviewType != null) {
      params[ApiConstants.interviewTypeParam] = interviewType!.value;
    }
    if (status != null) {
      params[ApiConstants.statusParam] = status!.value;
    }

    params[ApiConstants.limitParam] = limit.toString();
    params[ApiConstants.offsetParam] = offset.toString();

    return params;
  }

  /// Create a copy with updated fields
  InterviewFiltersModel copyWith({
    String? tenantId,
    String? projectId,
    String? advisorId,
    InterviewType? interviewType,
    InterviewStatus? status,
    int? limit,
    int? offset,
  }) {
    return InterviewFiltersModel(
      tenantId: tenantId ?? this.tenantId,
      projectId: projectId ?? this.projectId,
      advisorId: advisorId ?? this.advisorId,
      interviewType: interviewType ?? this.interviewType,
      status: status ?? this.status,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }

  /// Create filters with cleared optional filters
  InterviewFiltersModel clearFilters({
    required String tenantId,
  }) {
    return InterviewFiltersModel(
      tenantId: tenantId,
      limit: limit,
      offset: 0,
    );
  }

  /// Check if any filter is applied (excluding tenantId, limit, offset)
  bool get hasActiveFilters {
    return projectId != null ||
        advisorId != null ||
        interviewType != null ||
        status != null;
  }

  /// Get count of active filters
  int get activeFiltersCount {
    int count = 0;
    if (projectId != null) count++;
    if (advisorId != null) count++;
    if (interviewType != null) count++;
    if (status != null) count++;
    return count;
  }
}
