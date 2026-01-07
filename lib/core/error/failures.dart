import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode});

  @override
  List<Object> get props => [message, if (statusCode != null) statusCode!];
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Unauthorized access']);
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure([super.message = 'Forbidden: Insufficient permissions']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found']);
}

class ValidationFailure extends Failure {
  final Map<String, dynamic>? errors;
  const ValidationFailure(super.message, {this.errors});

  @override
  List<Object> get props => [message, if (errors != null) errors!];
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Request timeout']);
}
