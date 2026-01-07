import 'package:booster/core/error/failures.dart';
import 'package:booster/features/interviews/domain/usecases/create_interview.dart';
import 'package:booster/features/records/domain/usecases/upload_record.dart';
import 'package:booster/features/records/presentation/blocs/record_upload_event.dart';
import 'package:booster/features/records/presentation/blocs/record_upload_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecordUploadBloc extends Bloc<RecordUploadEvent, RecordUploadState> {
  final UploadRecord uploadRecord;
  final CreateInterview createInterview;

  RecordUploadBloc({
    required this.uploadRecord,
    required this.createInterview,
  }) : super(const RecordUploadInitial()) {
    on<RecordUploadStarted>(_onUploadStarted);
    on<RecordUploadRetried>(_onRetry);
    on<RecordUploadReset>(_onReset);
  }

  Future<void> _onUploadStarted(
    RecordUploadStarted event,
    Emitter<RecordUploadState> emit,
  ) async {
    emit(const RecordUploadInProgress());

    // Paso 1: Subir audio
    final uploadResult = await uploadRecord(
      UploadRecordParams(
        audioPath: event.audioPath,
        transcription: event.transcription ?? '',
      ),
    );

    await uploadResult.fold(
      (failure) async {
        emit(RecordUploadFailure(_mapFailureToMessage(failure)));
      },
      (data) async {
        final s3Key = data['s3_key'] as String;
        final audioId = data['audio_id'] as String;

        // Si no hay datos para crear interview, solo emitir success
        if (event.projectId == null ||
            event.tenantId == null ||
            event.advisorId == null ||
            event.interviewType == null) {
          emit(RecordUploadSuccess(s3Key: s3Key, audioId: audioId));
          return;
        }

        // Paso 2: Crear interview
        emit(InterviewCreating(s3Key: s3Key, audioId: audioId));

        final interviewResult = await createInterview(
          CreateInterviewParams(
            tenantId: event.tenantId!,
            projectId: event.projectId!,
            advisorId: event.advisorId!,
            interviewType: event.interviewType!,
            s3AudioKey: s3Key,
            startedAt: event.startedAt,
            endedAt: event.endedAt,
            durationSec: event.durationSec,
            providerUsed: 'GEMINI', // Por defecto GEMINI
          ),
        );

        interviewResult.fold(
          (failure) {
            emit(InterviewCreationFailed(
              message: _mapFailureToMessage(failure),
              s3Key: s3Key,
              audioId: audioId,
            ));
          },
          (interview) {
            emit(InterviewCreated(
              interviewId: interview.id,
              s3Key: s3Key,
              audioId: audioId,
            ));
          },
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
    if (failure is NetworkFailure) {
      return 'No hay conexión a internet';
    } else if (failure is UnauthorizedFailure) {
      return 'No autorizado. Por favor inicia sesión nuevamente';
    } else if (failure is ServerFailure) {
      return 'Error del servidor: ${failure.message}';
    }
    return failure.message;
  }
}
