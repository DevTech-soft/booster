sealed class RecordUploadEvent {
  const RecordUploadEvent();
}

class RecordUploadStarted extends RecordUploadEvent {
  final String audioPath;
  final String transcription;

  const RecordUploadStarted({
    required this.audioPath,
    required this.transcription,
  });
}


class RecordUploadRetried extends RecordUploadEvent {
  const RecordUploadRetried();
}

class RecordUploadReset extends RecordUploadEvent {
  const RecordUploadReset();
}
