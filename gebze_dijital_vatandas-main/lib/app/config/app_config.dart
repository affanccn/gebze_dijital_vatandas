import 'package:gebze_dijital_vatandas/app/config/flavor.dart';
import 'package:gebze_dijital_vatandas/app/config/data_mode.dart';

class AppConfig {
  final Flavor flavor;
  final DataMode dataMode;
  final String apiBaseUrl;
  final bool enableLogging;

  const AppConfig({
    required this.flavor,
    required this.dataMode,
    required this.apiBaseUrl,
    required this.enableLogging,
  });

  bool get isProd => flavor == Flavor.prod;
  bool get isMock => dataMode == DataMode.mock;
}
