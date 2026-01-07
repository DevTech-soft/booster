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

// Nuevos estados para creación de interview
class InterviewCreating extends RecordUploadState {
  final String s3Key;
  final String audioId;

  const InterviewCreating({
    required this.s3Key,
    required this.audioId,
  });
}

class InterviewCreated extends RecordUploadState {
  final String interviewId;
  final String s3Key;
  final String audioId;

  const InterviewCreated({
    required this.interviewId,
    required this.s3Key,
    required this.audioId,
  });
}

class InterviewCreationFailed extends RecordUploadState {
  final String message;
  final String s3Key;
  final String audioId;

  const InterviewCreationFailed({
    required this.message,
    required this.s3Key,
    required this.audioId,
  });
}
