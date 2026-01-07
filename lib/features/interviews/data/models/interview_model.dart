import 'package:booster/features/interviews/domain/entities/interview.dart';
import 'package:booster/features/interviews/domain/constants/interview_constants.dart';

/// Interview Model
/// Data layer model for Interview with JSON serialization
class InterviewModel extends Interview {
  const InterviewModel({
    required super.id,
    required super.tenantId,
    required super.projectId,
    required super.advisorId,
    required super.interviewType,
    required super.s3AudioKey,
    required super.languageCode,
    super.startedAt,
    super.endedAt,
    super.durationSec,
    required super.status,
    super.providerUsed,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Create InterviewModel from JSON
  factory InterviewModel.fromJson(Map<String, dynamic> json) {
    return InterviewModel(
      id: json['id'] as String,
      tenantId: json['tenant_id'] as String,
      projectId: json['project_id'] as String,
      advisorId: json['advisor_id'] as String,
      interviewType: InterviewType.fromString(json['interview_type'] as String),
      s3AudioKey: json['s3_audio_key'] as String,
      languageCode: json['language_code'] as String? ?? InterviewConstants.defaultLanguageCode,
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'] as String)
          : null,
      endedAt: json['ended_at'] != null
          ? DateTime.parse(json['ended_at'] as String)
          : null,
      durationSec: json['duration_sec'] as int?,
      status: InterviewStatus.fromString(json['status'] as String),
      providerUsed: json['provider_used'] != null
          ? ProcessingProvider.fromString(json['provider_used'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert InterviewModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenant_id': tenantId,
      'project_id': projectId,
      'advisor_id': advisorId,
      'interview_type': interviewType.value,
      's3_audio_key': s3AudioKey,
      'language_code': languageCode,
      if (startedAt != null) 'started_at': startedAt!.toIso8601String(),
      if (endedAt != null) 'ended_at': endedAt!.toIso8601String(),
      if (durationSec != null) 'duration_sec': durationSec,
      'status': status.value,
      if (providerUsed != null) 'provider_used': providerUsed!.value,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create InterviewModel from Interview entity
  factory InterviewModel.fromEntity(Interview interview) {
    return InterviewModel(
      id: interview.id,
      tenantId: interview.tenantId,
      projectId: interview.projectId,
      advisorId: interview.advisorId,
      interviewType: interview.interviewType,
      s3AudioKey: interview.s3AudioKey,
      languageCode: interview.languageCode,
      startedAt: interview.startedAt,
      endedAt: interview.endedAt,
      durationSec: interview.durationSec,
      status: interview.status,
      providerUsed: interview.providerUsed,
      createdAt: interview.createdAt,
      updatedAt: interview.updatedAt,
    );
  }

  /// Create a copy with updated fields
  InterviewModel copyWith({
    String? id,
    String? tenantId,
    String? projectId,
    String? advisorId,
    InterviewType? interviewType,
    String? s3AudioKey,
    String? languageCode,
    DateTime? startedAt,
    DateTime? endedAt,
    int? durationSec,
    InterviewStatus? status,
    ProcessingProvider? providerUsed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InterviewModel(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      projectId: projectId ?? this.projectId,
      advisorId: advisorId ?? this.advisorId,
      interviewType: interviewType ?? this.interviewType,
      s3AudioKey: s3AudioKey ?? this.s3AudioKey,
      languageCode: languageCode ?? this.languageCode,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      durationSec: durationSec ?? this.durationSec,
      status: status ?? this.status,
      providerUsed: providerUsed ?? this.providerUsed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
