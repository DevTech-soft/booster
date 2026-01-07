/// Application Permissions
/// Contains all permission constants used across the application
class Permissions {
  Permissions._();

  // Interview Permissions
  static const String interviewRead = 'INTERVIEW_READ';
  static const String interviewCreate = 'INTERVIEW_CREATE';
  static const String interviewUpdate = 'INTERVIEW_UPDATE';
  static const String interviewDelete = 'INTERVIEW_DELETE';
  static const String interviewAll = 'INTERVIEW_*';

  /// All interview permissions
  static const List<String> allInterviewPermissions = [
    interviewRead,
    interviewCreate,
    interviewUpdate,
    interviewDelete,
  ];

  // Add other feature permissions here as needed
  // Example:
  // static const String projectRead = 'PROJECT_READ';
  // static const String projectCreate = 'PROJECT_CREATE';
  // etc.
}

/// Permission Helper
class PermissionHelper {
  PermissionHelper._();

  /// Check if a permission list contains a specific permission
  static bool hasPermission(
    List<String> userPermissions,
    String requiredPermission,
  ) {
    // Check for exact match
    if (userPermissions.contains(requiredPermission)) {
      return true;
    }

    // Check for wildcard permissions
    // Example: INTERVIEW_* should match INTERVIEW_READ, INTERVIEW_CREATE, etc.
    final permissionPrefix = requiredPermission.split('_').first;
    final wildcardPermission = '${permissionPrefix}_*';

    return userPermissions.contains(wildcardPermission);
  }

  /// Check if user has all required permissions
  static bool hasAllPermissions(
    List<String> userPermissions,
    List<String> requiredPermissions,
  ) {
    return requiredPermissions.every(
      (permission) => hasPermission(userPermissions, permission),
    );
  }

  /// Check if user has any of the required permissions
  static bool hasAnyPermission(
    List<String> userPermissions,
    List<String> requiredPermissions,
  ) {
    return requiredPermissions.any(
      (permission) => hasPermission(userPermissions, permission),
    );
  }
}
