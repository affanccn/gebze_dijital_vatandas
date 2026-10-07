import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gebze_dijital_vatandas/app/config/app_config.dart';
import 'package:gebze_dijital_vatandas/app/config/feature_flags.dart';
import 'package:gebze_dijital_vatandas/core/logging/app_logger.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError('appConfigProvider must be overridden in bootstrap');
});

final featureFlagsProvider = Provider<FeatureFlags>((ref) {
  return const FeatureFlags.allEnabled();
});

final appLoggerProvider = Provider<AppLogger>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config.enableLogging) {
    return const DebugPrintLogger();
  }
  return const NoopLogger();
});
