import 'package:booster/core/error/failures.dart';
import 'package:booster/features/records/domain/usecases/upload_record.dart';
import 'package:booster/features/records/presentation/blocs/record_upload_event.dart';
import 'package:booster/features/records/presentation/blocs/record_upload_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecordUploadBloc extends Bloc<RecordUploadEvent, RecordUploadState> {
  final UploadRecord uploadRecord;

  RecordUploadBloc({required this.uploadRecord})
    : super(const RecordUploadInitial()) {
    on<RecordUploadStarted>(_onUploadStarted);
    on<RecordUploadRetried>(_onRetry);
    on<RecordUploadReset>(_onReset);
  }

  Future<void> _onUploadStarted(
    RecordUploadStarted event,
    Emitter<RecordUploadState> emit,
  ) async {
    emit(const RecordUploadInProgress());

    final result = await uploadRecord(
      UploadRecordParams(
        audioPath: event.audioPath,
        transcription: event.transcription ?? '',
      ),
    );

    result.fold(
      (failure) {
        emit(RecordUploadFailure(_mapFailureToMessage(failure)));
      },
      (data) {
        emit(
          RecordUploadSuccess(
            s3Key: data['s3_key'] as String,
            audioId: data['audio_id'] as String,
          ),
        );
      },
    );
  }

  void _onRetry(RecordUploadRetried event, Emitter<RecordUploadState> emit) {
    emit(const RecordUploadInitial());
  }

  void _onReset(RecordUploadReset event, Emitter<RecordUploadState> emit) {
    emit(const RecordUploadInitial());
  }

  String _mapFailureToMessage(Failure failure) {
    // Ajusta según tus Failures reales
    return failure.message;
  }
}
