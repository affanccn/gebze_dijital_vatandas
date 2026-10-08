import 'package:gebze_dijital_vatandas/bootstrap.dart';
import 'package:gebze_dijital_vatandas/app/config/app_config.dart';
import 'package:gebze_dijital_vatandas/app/config/flavor.dart';
import 'package:gebze_dijital_vatandas/app/config/data_mode.dart';

void main() {
  const config = AppConfig(
    flavor: Flavor.staging,
    dataMode: DataMode.remote,
    apiBaseUrl: 'https://api.staging.invalid',
    enableLogging: true,
  );
  bootstrap(config);
}
