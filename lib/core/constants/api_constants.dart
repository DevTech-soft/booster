/// API Constants for the application
/// Contains all API endpoints and configuration
class ApiConstants {
  ApiConstants._();

  // Base paths
  static const String baseApiPath = '/api';

  // Interview endpoints
  static const String interviewsPath = '$baseApiPath/interviews';

  static String interviewByIdPath(String id) => '$interviewsPath/$id';

  // Headers
  static const String apiKeyHeader = 'X-API-Key';
  static const String contentTypeHeader = 'Content-Type';
  static const String authorizationHeader = 'Authorization';

  // Content types
  static const String jsonContentType = 'application/json';
  static const String audioMp4ContentType = 'audio/mp4';

  // Query parameters
  static const String tenantIdParam = 'tenant_id';
  static const String projectIdParam = 'project_id';
  static const String advisorIdParam = 'advisor_id';
  static const String interviewTypeParam = 'interview_type';
  static const String statusParam = 'status';
  static const String limitParam = 'limit';
  static const String offsetParam = 'offset';

  // Default values
  static const int defaultLimit = 20;
  static const int defaultOffset = 0;
  static const int maxLimit = 100;
}
