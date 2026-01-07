import 'dart:io';
import 'package:booster/core/error/exceptions.dart';
import 'package:http/http.dart' as http;

/// HTTP Error Handler
/// Handles HTTP responses and throws appropriate exceptions
class HttpErrorHandler {
  HttpErrorHandler._();

  /// Handle HTTP response and throw exception if status code indicates error
  static void handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 204:
        // Success - no exception
        return;
      case 400:
        throw ValidationException(
          'Bad Request: ${response.body}',
        );
      case 401:
        throw const UnauthorizedException();
      case 403:
        throw const ForbiddenException();
      case 404:
        throw const NotFoundException();
      case 408:
        throw const TimeoutException();
      case 500:
      case 502:
      case 503:
      case 504:
        throw ServerException(
          'Server Error: ${response.body}',
          statusCode: response.statusCode,
        );
      default:
        throw ServerException(
          'Unexpected Error: ${response.body}',
          statusCode: response.statusCode,
        );
    }
  }

  /// Handle general exceptions and convert to appropriate exception type
  static Exception handleException(dynamic error) {
    if (error is SocketException) {
      return const NetworkException('No internet connection');
    } else if (error is HttpException) {
      return ServerException('HTTP Error: ${error.message}');
    } else if (error is FormatException) {
      return ServerException('Invalid response format: ${error.message}');
    } else if (error is ServerException ||
        error is NetworkException ||
        error is CacheException ||
        error is UnauthorizedException ||
        error is ForbiddenException ||
        error is NotFoundException ||
        error is ValidationException ||
        error is TimeoutException) {
      return error as Exception;
    } else {
      return ServerException('Unexpected error: ${error.toString()}');
    }
  }
}
