class ServerException implements Exception {
  final String message;
  final int? statusCode;
  const ServerException(this.message, {this.statusCode});
}

class CacheException implements Exception {
  final String message;
  const CacheException(this.message);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
}

class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException([this.message = 'Unauthorized access']);
}

class ForbiddenException implements Exception {
  final String message;
  const ForbiddenException([this.message = 'Forbidden: Insufficient permissions']);
}

class NotFoundException implements Exception {
  final String message;
  const NotFoundException([this.message = 'Resource not found']);
}

class ValidationException implements Exception {
  final String message;
  final Map<String, dynamic>? errors;
  const ValidationException(this.message, {this.errors});
}

class TimeoutException implements Exception {
  final String message;
  const TimeoutException([this.message = 'Request timeout']);
}
