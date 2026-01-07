import 'package:booster/features/interviews/domain/entities/interview_segment.dart';

/// Interview Segment Model
/// Data layer model for InterviewSegment with JSON serialization
class InterviewSegmentModel extends InterviewSegment {
  const InterviewSegmentModel({
    required super.id,
    required super.interviewId,
    required super.segmentIndex,
    super.startSec,
    super.endSec,
    required super.text,
    required super.createdAt,
  });

  /// Create InterviewSegmentModel from JSON
  factory InterviewSegmentModel.fromJson(Map<String, dynamic> json) {
    return InterviewSegmentModel(
      id: json['id'] as String,
      interviewId: json['interview_id'] as String,
      segmentIndex: json['segment_index'] as int,
      startSec: json['start_sec'] as int?,
      endSec: json['end_sec'] as int?,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Convert InterviewSegmentModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'interview_id': interviewId,
      'segment_index': segmentIndex,
      if (startSec != null) 'start_sec': startSec,
      if (endSec != null) 'end_sec': endSec,
      'text': text,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Create InterviewSegmentModel from InterviewSegment entity
  factory InterviewSegmentModel.fromEntity(InterviewSegment segment) {
    return InterviewSegmentModel(
      id: segment.id,
      interviewId: segment.interviewId,
      segmentIndex: segment.segmentIndex,
      startSec: segment.startSec,
      endSec: segment.endSec,
      text: segment.text,
      createdAt: segment.createdAt,
    );
  }
}
