import 'dart:async';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:gebze_dijital_vatandas/core/error/app_failure.dart';
import 'package:gebze_dijital_vatandas/core/error/error_mapper.dart';

void main() {
  group('mapToFailure', () {
    test('returns AppFailure directly when error is an AppFailure', () {
      const failure = PermissionFailure('Permission denied');
      final result = mapToFailure(failure);
      expect(result, isA<PermissionFailure>());
      expect(result, equals(failure));
    });

    test('returns TimeoutFailure when error is TimeoutException', () {
      final error = TimeoutException('Timeout occurred');
      final result = mapToFailure(error);
      expect(result, isA<TimeoutFailure>());
      expect(result.cause, equals(error));
    });

    test('returns NetworkFailure when error is SocketException', () {
      const error = SocketException('Failed host lookup');
      final result = mapToFailure(error);
      expect(result, isA<NetworkFailure>());
      expect(result.cause, equals(error));
    });

    test('returns UnknownFailure for a random Exception and keeps the cause', () {
      final error = Exception('Random exception');
      final result = mapToFailure(error);
      expect(result, isA<UnknownFailure>());
      expect(result.cause, equals(error));
    });
  });
}
