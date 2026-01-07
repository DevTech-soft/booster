import 'package:booster/features/interviews/data/models/interview_model.dart';

/// Interviews List Response Model
/// Represents the response from GET /api/interviews endpoint
class InterviewsResponseModel {
  final List<InterviewModel> interviews;
  final int total;

  const InterviewsResponseModel({
    required this.interviews,
    required this.total,
  });

  /// Create InterviewsResponseModel from JSON
  factory InterviewsResponseModel.fromJson(Map<String, dynamic> json) {
    return InterviewsResponseModel(
      interviews: (json['interviews'] as List<dynamic>)
          .map((item) => InterviewModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
    );
  }

  /// Convert InterviewsResponseModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'interviews': interviews.map((interview) => interview.toJson()).toList(),
      'total': total,
    };
  }

  /// Check if there are more items to load
  bool get hasMore => interviews.length < total;
}
