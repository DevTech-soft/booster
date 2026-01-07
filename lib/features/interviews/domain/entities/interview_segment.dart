import 'package:equatable/equatable.dart';

/// Interview Segment Entity
/// Represents a segment (chunk) of text from an interview transcript
class InterviewSegment extends Equatable {
  final String id;
  final String interviewId;
  final int segmentIndex;
  final int? startSec;
  final int? endSec;
  final String text;
  final DateTime createdAt;

  const InterviewSegment({
    required this.id,
    required this.interviewId,
    required this.segmentIndex,
    this.startSec,
    this.endSec,
    required this.text,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        interviewId,
        segmentIndex,
        startSec,
        endSec,
        text,
        createdAt,
      ];

  /// Get formatted time range (e.g., "1:30 - 2:45")
  String get formattedTimeRange {
    if (startSec == null || endSec == null) return 'N/A';
    return '${_formatSeconds(startSec!)} - ${_formatSeconds(endSec!)}';
  }

  /// Format seconds to MM:SS
  String _formatSeconds(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  /// Get duration in seconds
  int? get durationSec {
    if (startSec == null || endSec == null) return null;
    return endSec! - startSec!;
  }
}
