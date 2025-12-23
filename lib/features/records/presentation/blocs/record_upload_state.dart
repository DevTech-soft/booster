sealed class RecordUploadState {
  const RecordUploadState();
}

class RecordUploadInitial extends RecordUploadState {
  const RecordUploadInitial();
}

class RecordUploadInProgress extends RecordUploadState {
  const RecordUploadInProgress();
}

class RecordUploadSuccess extends RecordUploadState {
  final String s3Key;
  final String audioId;

  const RecordUploadSuccess({
    required this.s3Key,
    required this.audioId,
  });
}

class RecordUploadFailure extends RecordUploadState {
  final String message;

  const RecordUploadFailure(this.message);
}
