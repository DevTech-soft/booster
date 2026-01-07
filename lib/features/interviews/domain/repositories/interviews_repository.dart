import 'package:dartz/dartz.dart';
import 'package:booster/core/error/failures.dart';
import 'package:booster/features/interviews/data/models/interview_filters_model.dart';
import 'package:booster/features/interviews/domain/entities/interview.dart';

/// Interviews Repository Interface
/// Defines the contract for interviews data operations
abstract class InterviewsRepository {
  /// Get list of interviews with optional filters
  /// Returns Either<Failure, (List<Interview>, int total)>
  Future<Either<Failure, (List<Interview>, int)>> getInterviews(
    InterviewFiltersModel filters,
  );

  /// Get a specific interview by ID
  /// Returns Either<Failure, Interview>
  Future<Either<Failure, Interview>> getInterviewById(String id);

  /// Create a new interview
  /// Returns Either<Failure, Interview>
  Future<Either<Failure, Interview>> createInterview(
    Map<String, dynamic> data,
  );

  /// Update an existing interview
  /// Returns Either<Failure, Interview>
  Future<Either<Failure, Interview>> updateInterview(
    String id,
    Map<String, dynamic> data,
  );

  /// Delete an interview
  /// Returns Either<Failure, void>
  Future<Either<Failure, void>> deleteInterview(String id);
}
