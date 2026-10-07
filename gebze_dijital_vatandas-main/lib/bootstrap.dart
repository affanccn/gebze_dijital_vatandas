import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gebze_dijital_vatandas/app/app.dart';
import 'package:gebze_dijital_vatandas/app/config/app_config.dart';
import 'package:gebze_dijital_vatandas/app/config/config_providers.dart';
import 'package:gebze_dijital_vatandas/core/logging/app_logger.dart';

Future<void> bootstrap(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();

  const globalLogger = DebugPrintLogger();

  FlutterError.onError = (details) {
    globalLogger.error('Flutter Error', error: details.exception, stackTrace: details.stack);
    // TODO: platform/crash_reporting bağlanacak
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    globalLogger.error('Platform Dispatcher Error', error: error, stackTrace: stack);
    // TODO: platform/crash_reporting bağlanacak
    return true;
  };

  runApp(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(config),
      ],
      child: const App(),
    ),
  );
}
