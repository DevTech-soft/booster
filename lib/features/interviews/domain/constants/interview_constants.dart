/// Interview feature constants
class InterviewConstants {
  InterviewConstants._();

  // Interview Types
  static const String typeVisita = 'VISITA';
  static const String typeCliente = 'CLIENTE';

  // Interview Status
  static const String statusReceived = 'RECEIVED';
  static const String statusTranscribed = 'TRANSCRIBED';
  static const String statusEmbedded = 'EMBEDDED';
  static const String statusIndexed = 'INDEXED';
  static const String statusFailed = 'FAILED';

  // Processing Providers
  static const String providerGemini = 'GEMINI';
  static const String providerTranscribe = 'TRANSCRIBE';

  // Default values
  static const String defaultLanguageCode = 'es-PE';

  // Permissions
  static const String permissionRead = 'INTERVIEW_READ';
  static const String permissionCreate = 'INTERVIEW_CREATE';
  static const String permissionUpdate = 'INTERVIEW_UPDATE';
  static const String permissionDelete = 'INTERVIEW_DELETE';
  static const String permissionAll = 'INTERVIEW_*';
}

/// Interview Type Enum
enum InterviewType {
  visita('VISITA'),
  cliente('CLIENTE');

  final String value;
  const InterviewType(this.value);

  static InterviewType fromString(String value) {
    switch (value.toUpperCase()) {
      case 'VISITA':
        return InterviewType.visita;
      case 'CLIENTE':
        return InterviewType.cliente;
      default:
        throw ArgumentError('Unknown interview type: $value');
    }
  }
}

/// Interview Status Enum
enum InterviewStatus {
  received('RECEIVED'),
  transcribed('TRANSCRIBED'),
  embedded('EMBEDDED'),
  indexed('INDEXED'),
  failed('FAILED');

  final String value;
  const InterviewStatus(this.value);

  static InterviewStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'RECEIVED':
        return InterviewStatus.received;
      case 'TRANSCRIBED':
        return InterviewStatus.transcribed;
      case 'EMBEDDED':
        return InterviewStatus.embedded;
      case 'INDEXED':
        return InterviewStatus.indexed;
      case 'FAILED':
        return InterviewStatus.failed;
      default:
        throw ArgumentError('Unknown interview status: $value');
    }
  }

  /// Returns true if the interview is still being processed
  bool get isProcessing =>
      this == InterviewStatus.received ||
      this == InterviewStatus.transcribed ||
      this == InterviewStatus.embedded;

  /// Returns true if the interview has completed processing
  bool get isCompleted => this == InterviewStatus.indexed;

  /// Returns true if the interview has failed
  bool get hasFailed => this == InterviewStatus.failed;
}

/// Processing Provider Enum
enum ProcessingProvider {
  gemini('GEMINI'),
  transcribe('TRANSCRIBE');

  final String value;
  const ProcessingProvider(this.value);

  static ProcessingProvider? fromString(String? value) {
    if (value == null) return null;
    switch (value.toUpperCase()) {
      case 'GEMINI':
        return ProcessingProvider.gemini;
      case 'TRANSCRIBE':
        return ProcessingProvider.transcribe;
      default:
        return null;
    }
  }
}
