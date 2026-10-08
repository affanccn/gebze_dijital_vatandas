import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Cihaz eğimini -1..1 aralığında bir Offset olarak yayınlar.
///  dx > 0  -> cihazın sağ tarafı aşağıda
///  dy > 0  -> cihazın üst tarafı sana doğru (ekran yukarı bakıyor)
/// İşaretler istediğin yönde değilse [invertX] / [invertY] kullan.
///
/// Mutlak açı yerine "tutuş pozisyonuna göre fark" kullanır: telefon nasıl
/// tutulursa tutulsun yavaşça merkeze oturur, bot sürekli yan yatmış kalmaz.
class Bot82TiltSource {
  Bot82TiltSource({this.invertX = false, this.invertY = false});

  final bool invertX;
  final bool invertY;
  final ValueNotifier<Offset> tilt = ValueNotifier(Offset.zero);

  StreamSubscription<AccelerometerEvent>? _sub;
  double _baseX = 0, _baseZ = 0, _sx = 0, _sy = 0;
  bool _hasBase = false;

  void start() {
    if (_sub != null) return;
    _hasBase = false;
    _sub = accelerometerEventStream(samplingPeriod: SensorInterval.gameInterval)
        .listen(_onEvent, onError: (_) {/* emülatör/web: sensör yok */});
  }

  void stop() {
    _sub?.cancel();
    _sub = null;
  }

  void _onEvent(AccelerometerEvent e) {
    if (!_hasBase) {
      _baseX = e.x;
      _baseZ = e.z;
      _hasBase = true;
    }
    // Yavaş baz çizgisi (tutuş pozisyonuna adaptasyon)
    _baseX += (e.x - _baseX) * 0.012;
    _baseZ += (e.z - _baseZ) * 0.012;

    // ~4 m/s² fark = tam eğim
    final nx = (-(e.x - _baseX) / 4).clamp(-1.0, 1.0);
    final ny = ((e.z - _baseZ) / 4).clamp(-1.0, 1.0);

    // Low-pass filtre: titreşimi yumuşat
    _sx += (nx - _sx) * 0.14;
    _sy += (ny - _sy) * 0.14;

    final next = Offset(invertX ? -_sx : _sx, invertY ? -_sy : _sy);
    if ((next - tilt.value).distanceSquared > 0.00005) tilt.value = next;
  }

  void dispose() {
    stop();
    tilt.dispose();
  }
}
