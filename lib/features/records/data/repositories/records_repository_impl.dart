import 'dart:io';

import 'package:booster/core/error/exceptions.dart';
import 'package:booster/core/error/failures.dart';
import 'package:booster/features/records/data/datasources/records_remote_datasource.dart';
import 'package:booster/features/records/domain/repositories/records_repository.dart';
import 'package:booster/features/records/domain/usecases/upload_record.dart';
import 'package:dartz/dartz.dart';

class RecordsRepositoryImpl implements RecordsRepository {
  final RecordsRemoteDatasource remoteDataSource;

  RecordsRepositoryImpl({ required this.remoteDataSource});
  @override
  Future<Either<Failure, Map<String, dynamic>>> uploadRecord(UploadRecordParams record)async {
    
    try {
      final Map<String, dynamic>  result = await remoteDataSource.uploadRecord(record);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
      
    } on IOException {
      return Left(NetworkFailure('Network error occurred'));
    }
  }
}