import 'package:booster/features/interviews/domain/entities/interview.dart';

class InterviewModel extends Interview {
 const InterviewModel({
    required super.id,
    required super.tenantId,
    required super.clientId,
    required super.proyectId,
    required super.advisorId,
    required super.interviewType,
    required super.s3AudioKey,
  });
  factory InterviewModel.fromJson(Map<String, dynamic> json) {
    return InterviewModel(
      id: json['id'],
      tenantId: json['tenant_id'],
      clientId: json['client_id'],
      proyectId: json['proyect_id'],
      advisorId: json['advisor_id'],
      interviewType: json['interview_type'],
      s3AudioKey: json['s3_audio_key'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenant_id': tenantId,
      'client_id': clientId,
      'proyect_id': proyectId,
      'advisor_id': advisorId,
      'interview_type': interviewType,
      's3_audio_key': s3AudioKey,
    };
  }
  factory InterviewModel.fromEntity(Interview interview) {
    return InterviewModel(
      id: interview.id,
      tenantId: interview.tenantId,
      clientId: interview.clientId,
      proyectId: interview.proyectId,
      advisorId: interview.advisorId,
      interviewType: interview.interviewType,
      s3AudioKey: interview.s3AudioKey,
    );
  }
}
