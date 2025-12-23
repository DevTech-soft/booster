import 'package:booster/core/error/failures.dart';
import 'package:booster/features/records/domain/usecases/upload_record.dart';
import 'package:dartz/dartz.dart';

abstract class RecordsRepository {
  Future<Either<Failure, Map<String, dynamic>>> uploadRecord(UploadRecordParams record);
}