import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:booster/core/error/exceptions.dart';
import 'package:booster/features/records/domain/usecases/upload_record.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

abstract class RecordsRemoteDatasource {
  Future<Map<String, dynamic>> uploadRecord(UploadRecordParams params);
}

class RecordsRemoteDatasourceImpl implements RecordsRemoteDatasource {
  final String apiUrl = dotenv.env['API_URL'] ?? '';
  @override
  Future<Map<String, dynamic>> uploadRecord(UploadRecordParams params) async {
    final file = File(params.audioPath);
    final filename = file.uri.pathSegments.last;
    Map<String, dynamic> presignedUploadResponse = {};
    log('filename: $filename');
    log('audio type: ${params.audioType}');
    final presignResponse = await http.post(
      Uri.parse('$apiUrl/upload/presign'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'tenant': params.tenant,
        'audio_type': params.audioType,
        'filename': filename,
        'project_id': params.projectId,
        'client_id': params.clientId,
        'advisor_id': params.advisorId,
      }),
    );

    if (presignResponse.statusCode != 200) {
      throw ServerException(
        'Error presign: ${presignResponse.body} (${presignResponse.statusCode})',
      );
    }

    final presignData = jsonDecode(presignResponse.body);

    final String uploadUrl = presignData['upload_url'];
    final String s3Key = presignData['s3_key'];
    final String audioId = presignData['audio_id'];

    log('Upload URL: $uploadUrl');
    log('S3 Key: $s3Key');
    log('Audio ID: $audioId');

    final bytes = await file.readAsBytes();
    final uploadResponse = await http.put(
      Uri.parse(uploadUrl),
      headers: {
        'Content-Type': 'audio/mp4',
        'x-amz-meta-audio_id': audioId,
        'x-amz-meta-audio_type': params.audioType,
        'x-amz-meta-advisor_id': params.advisorId,
        'x-amz-meta-client_id': params.clientId,
        'x-amz-meta-project_id': params.projectId,
        'x-amz-meta-tenant_id': params.tenant,
      },
      body: bytes,
    );
    if (uploadResponse.statusCode != 200) {
      throw ServerException(
        'Error upload S3: ${uploadResponse.statusCode} - ${uploadResponse.body}',
      );
    }

    return presignedUploadResponse = {'s3_key': s3Key, 'audio_id': audioId};
  }
}
