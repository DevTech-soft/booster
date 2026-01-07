import 'dart:convert';
import 'dart:developer';
import 'package:booster/core/constants/api_constants.dart';
import 'package:booster/core/error/exceptions.dart';
import 'package:booster/core/utils/http_error_handler.dart';
import 'package:booster/features/interviews/data/models/interview_filters_model.dart';
import 'package:booster/features/interviews/data/models/interview_model.dart';
import 'package:booster/features/interviews/data/models/interviews_response_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Remote Data Source for Interviews
/// Handles all HTTP requests to the interviews API
abstract class InterviewsRemoteDataSource {
  /// Get list of interviews with optional filters
  Future<InterviewsResponseModel> getInterviews(
    InterviewFiltersModel filters,
  );

  /// Get a specific interview by ID
  Future<InterviewModel> getInterviewById(String id);

  /// Create a new interview
  Future<InterviewModel> createInterview(Map<String, dynamic> data);

  /// Update an existing interview
  Future<InterviewModel> updateInterview(String id, Map<String, dynamic> data);

  /// Delete an interview
  Future<void> deleteInterview(String id);
}

class InterviewsRemoteDataSourceImpl implements InterviewsRemoteDataSource {
  final http.Client client;
  final String apiUrl = dotenv.env['API_URL'] ?? '';
  final String apiKey = dotenv.env['API_KEY'] ?? '';

  InterviewsRemoteDataSourceImpl({required this.client});

  /// Get common headers for API requests
  Map<String, String> get _headers => {
        ApiConstants.apiKeyHeader: apiKey,
        ApiConstants.contentTypeHeader: ApiConstants.jsonContentType,
      };

  @override
  Future<InterviewsResponseModel> getInterviews(
    InterviewFiltersModel filters,
  ) async {
    try {
      final queryParams = filters.toQueryParams();
      final uri = Uri.parse('$apiUrl${ApiConstants.interviewsPath}')
          .replace(queryParameters: queryParams);

      log('GET $uri');

      final response = await client.get(
        uri,
        headers: _headers,
      );

      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      HttpErrorHandler.handleResponse(response);

      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      return InterviewsResponseModel.fromJson(jsonData);
    } catch (e) {
      log('Error in getInterviews: $e');
      throw HttpErrorHandler.handleException(e);
    }
  }

  @override
  Future<InterviewModel> getInterviewById(String id) async {
    try {
      final uri = Uri.parse('$apiUrl${ApiConstants.interviewByIdPath(id)}');

      log('GET $uri');

      final response = await client.get(
        uri,
        headers: _headers,
      );

      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      HttpErrorHandler.handleResponse(response);

      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      return InterviewModel.fromJson(jsonData);
    } catch (e) {
      log('Error in getInterviewById: $e');
      throw HttpErrorHandler.handleException(e);
    }
  }

  @override
  Future<InterviewModel> createInterview(Map<String, dynamic> data) async {
    try {
      final uri = Uri.parse('$apiUrl${ApiConstants.interviewsPath}');

      log('POST $uri');
      log('Body: ${jsonEncode(data)}');

      final response = await client.post(
        uri,
        headers: _headers,
        body: jsonEncode(data),
      );

      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      HttpErrorHandler.handleResponse(response);

      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      return InterviewModel.fromJson(jsonData);
    } catch (e) {
      log('Error in createInterview: $e');
      throw HttpErrorHandler.handleException(e);
    }
  }

  @override
  Future<InterviewModel> updateInterview(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final uri = Uri.parse('$apiUrl${ApiConstants.interviewByIdPath(id)}');

      log('PUT $uri');
      log('Body: ${jsonEncode(data)}');

      final response = await client.put(
        uri,
        headers: _headers,
        body: jsonEncode(data),
      );

      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      HttpErrorHandler.handleResponse(response);

      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      return InterviewModel.fromJson(jsonData);
    } catch (e) {
      log('Error in updateInterview: $e');
      throw HttpErrorHandler.handleException(e);
    }
  }

  @override
  Future<void> deleteInterview(String id) async {
    try {
      final uri = Uri.parse('$apiUrl${ApiConstants.interviewByIdPath(id)}');

      log('DELETE $uri');

      final response = await client.delete(
        uri,
        headers: _headers,
      );

      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      HttpErrorHandler.handleResponse(response);
    } catch (e) {
      log('Error in deleteInterview: $e');
      throw HttpErrorHandler.handleException(e);
    }
  }
}
