import 'dart:async';
import 'dart:io';
import 'package:gebze_dijital_vatandas/core/error/app_failure.dart';

AppFailure mapToFailure(Object error, [StackTrace? stackTrace]) {
  if (error is AppFailure) {
    return error;
  }
  if (error is TimeoutException) {
    return TimeoutFailure('Connection timeout', error, stackTrace);
  }
  if (error is SocketException) {
    return NetworkFailure('Network connection failed', error, stackTrace);
  }
  return UnknownFailure('An unexpected error occurred', error, stackTrace);
}
