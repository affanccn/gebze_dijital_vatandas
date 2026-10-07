sealed class AppFailure implements Exception {
  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  const AppFailure(this.message, [this.cause, this.stackTrace]);

  @override
  String toString() {
    return '$runtimeType: $message${cause != null ? '\nCause: $cause' : ''}';
  }
}

class NetworkFailure extends AppFailure {
  const NetworkFailure(super.message, [super.cause, super.stackTrace]);
}

class TimeoutFailure extends AppFailure {
  const TimeoutFailure(super.message, [super.cause, super.stackTrace]);
}

class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure(super.message, [super.cause, super.stackTrace]);
}

class ForbiddenFailure extends AppFailure {
  const ForbiddenFailure(super.message, [super.cause, super.stackTrace]);
}

class NotFoundFailure extends AppFailure {
  const NotFoundFailure(super.message, [super.cause, super.stackTrace]);
}

class ValidationFailure extends AppFailure {
  final Map<String, String> fieldErrors;

  const ValidationFailure(super.message, [super.cause, super.stackTrace, this.fieldErrors = const {}]);
}

class ServerFailure extends AppFailure {
  final int? statusCode;

  const ServerFailure(super.message, [super.cause, super.stackTrace, this.statusCode]);
}

class PermissionFailure extends AppFailure {
  const PermissionFailure(super.message, [super.cause, super.stackTrace]);
}

class LocationUnavailableFailure extends AppFailure {
  const LocationUnavailableFailure(super.message, [super.cause, super.stackTrace]);
}

class CacheMissFailure extends AppFailure {
  const CacheMissFailure(super.message, [super.cause, super.stackTrace]);
}

class UnknownFailure extends AppFailure {
  const UnknownFailure(super.message, [super.cause, super.stackTrace]);
}
