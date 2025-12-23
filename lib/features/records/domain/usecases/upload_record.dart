import 'package:booster/core/error/failures.dart';
import 'package:booster/core/usecases/usecase.dart';
import 'package:booster/features/records/domain/repositories/records_repository.dart';
import 'package:dartz/dartz.dart';

class UploadRecord
    implements UseCase<Either<Failure, Map<String, dynamic>>, UploadRecordParams> {
  final RecordsRepository recordsRepository;

  UploadRecord( this.recordsRepository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(UploadRecordParams params) {
    return recordsRepository.uploadRecord(params);
  }
}

class UploadRecordParams {
  final String audioPath;
  final String? transcription;

  UploadRecordParams({required this.audioPath, required this.transcription});
}
