import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'bot82_state.dart';
import 'bot82_tilt_source.dart';

const _cyan = Color(0xFF22D3EE);

/// assets/images/bot82_full.png (512x615) için ölçüler.
const double kBot82Aspect = 0.833;

/// Robotun ekran (yüz) alanı: görselin oranları (left, top, width, height).
const Rect kBot82FaceRect = Rect.fromLTWH(0.37, 0.058, 0.285, 0.185);

/// Yaşayan, pseudo-3D Bot82.
///
/// Katmanlar (alttan üste): gölge -> glow -> gövde(+parallax/shine/tint) -> [head] -> düşünme yüzü.
/// Tüm animasyon tek bir AnimatedBuilder içinde; widget ağacı yeniden kurulmaz,
/// görsel `child` olarak sabit kalır -> 60fps.
class Bot82Fab extends ConsumerStatefulWidget {
  const Bot82Fab({
    super.key,
    required this.onTap,
    this.width = 88,
    this.aspect = kBot82Aspect,
    this.bodyAsset = 'assets/images/bot82_full.png',
    this.headAsset,
    this.faceRect = kBot82FaceRect,
    this.artBuilder,
    this.tiltSource,
  });

  final VoidCallback onTap;
  final double width;

  /// Kırpılmış PNG'nin genişlik/yükseklik oranı.
  final double aspect;
  final String bodyAsset;

  /// (Opsiyonel) Kafayı ayrı katman olarak verirsen parallax'ta gövdeden
  /// daha fazla hareket eder -> gerçek derinlik hissi.
  final String? headAsset;

  /// Robotun ekran (yüz) alanı: kırpılmış görselin oranları (left, top, width, height).
  final Rect faceRect;

  /// 3D altyapısı: PNG yerine Rive / Lottie / glb (flutter_3d_controller) koymak için.
  /// Float, eğim, gölge, bounce ve thinking efektleri yine sarmalayıcıdan gelir.
  final WidgetBuilder? artBuilder;

  final Bot82TiltSource? tiltSource;

  double get height => width / aspect;
  double get totalHeight => height + width * 0.2;

  @override
  ConsumerState<Bot82Fab> createState() => _Bot82FabState();
}

class _Bot82FabState extends ConsumerState<Bot82Fab>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _float; // idle süzülme
  late final AnimationController _think; // kalp atışı + nokta animasyonu
  late final AnimationController _blend; // thinking görünüm geçişi 0..1
  late final AnimationController _tap; // spring (unbounded)
  late final Animation<double> _heart;
  late final Bot82TiltSource _tilt;
  late final bool _ownsTilt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _float = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);

    _think = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _heart = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 10),
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 12),
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 0.6)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 9),
      TweenSequenceItem(
          tween: Tween(begin: 0.6, end: 0.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 14),
      TweenSequenceItem(tween: ConstantTween<double>(0), weight: 55),
    ]).animate(_think);

    _blend = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    )..addStatusListener((s) {
        if (s == AnimationStatus.dismissed) _think.stop();
      });

    _tap = AnimationController.unbounded(vsync: this, value: 0);

    _ownsTilt = widget.tiltSource == null;
    _tilt = widget.tiltSource ?? Bot82TiltSource();
    _tilt.start();

    // Provider zaten thinking'deyse (örn. widget yeniden kurulduysa) senkronla.
    if (ref.read(bot82Provider).mode == Bot82Mode.thinking) {
      _enterThinking();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _tilt.start();
    } else {
      _tilt.stop(); // arka planda sensörü kapat -> pil
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _float.dispose();
    _think.dispose();
    _blend.dispose();
    _tap.dispose();
    _ownsTilt ? _tilt.dispose() : _tilt.stop();
    super.dispose();
  }

  void _enterThinking() {
    _think.repeat();
    _blend.forward();
  }

  void _onMode(Bot82Mode? prev, Bot82Mode next) {
    switch (next) {
      case Bot82Mode.thinking:
        _enterThinking();
      case Bot82Mode.idle:
        _blend.reverse();
      case Bot82Mode.tapped:
        break; // thinking görünümü bozulmasın; zıplama _handleTap'ta
    }
  }

  /// Squash -> fırlama -> yaylı iniş.
  void _bounce() {
    const spring = SpringDescription(mass: 1, stiffness: 330, damping: 12);
    _tap.value = -0.55; // ezilmiş başlangıç
    _tap.animateWith(SpringSimulation(spring, -0.55, 0.0, 15.0));
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    ref.read(bot82Provider.notifier).registerTap();
    _bounce();
    // Zıplama görünsün, sonra sohbet yumuşakça açılsın.
    Future.delayed(const Duration(milliseconds: 280), () {
      if (mounted) widget.onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<Bot82Mode>(bot82Provider.select((s) => s.mode), _onMode);

    final w = widget.width;
    final h = widget.height;
    final dpr = MediaQuery.devicePixelRatioOf(context);

    // Sabit alt ağaç: görseller her karede yeniden kurulmaz.
    final art = widget.artBuilder?.call(context) ??
        Image.asset(
          widget.bodyAsset,
          width: w,
          height: h,
          fit: BoxFit.contain,
          cacheWidth: (w * dpr).ceil(),
          filterQuality: FilterQuality.medium,
          gaplessPlayback: true,
          errorBuilder: (_, __, ___) => const Icon(Icons.smart_toy, size: 48),
        );

    return Semantics(
      button: true,
      label: 'Bot82 asistan, sohbeti aç',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _handleTap,
        child: RepaintBoundary(
          child: SizedBox(
            width: w,
            height: widget.totalHeight,
            child: AnimatedBuilder(
              animation: Listenable.merge([_float, _think, _blend, _tap, _tilt.tilt]),
              child: art,
              builder: (context, child) => _compose(w, h, child!),
            ),
          ),
        ),
      ),
    );
  }

  Widget _compose(double w, double h, Widget art) {
    final amp = w * 0.05;
    final f = Curves.easeInOutSine.transform(_float.value); // 0..1 (1 = en yukarı)
    final floatY = -(f * 2 - 1) * amp;
    final tilt = _tilt.tilt.value;
    final blend = _blend.value;
    final heart = _heart.value;
    final tap = _tap.value;
    final pulse = 0.5 + 0.5 * math.sin(2 * math.pi * _think.value);

    final jumpY = -tap * w * 0.32;
    final scaleY = (1 + tap * 0.12) * (1 + 0.07 * heart * blend);
    final scaleX = (1 - tap * 0.07) * (1 + 0.07 * heart * blend);

    // Gölge: bot yükseldikçe küçülür ve silikleşir.
    final altitude = (f * 0.5 + tap.clamp(0.0, 1.2) * 0.8).clamp(0.0, 1.2);
    final shadowScale = 1 - 0.2 * altitude;
    final shadowOpacity = (0.34 - 0.16 * altitude).clamp(0.05, 0.4);

    final perspective = Matrix4.identity()
      ..setEntry(3, 2, 0.0014)
      ..rotateX(-tilt.dy * 0.30)
      ..rotateY(tilt.dx * 0.38);

    // Yansıma bandı eğimle kayar (yalnızca opak piksellerde: srcATop).
    Widget body = ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (r) => LinearGradient(
        begin: Alignment(-1.4 - tilt.dx * 1.2, -1 - tilt.dy * 0.6),
        end: Alignment(0.6 - tilt.dx * 1.2, 1 - tilt.dy * 0.6),
        colors: [
          Colors.transparent,
          Colors.white.withValues(alpha: 0.30),
          Colors.transparent,
        ],
        stops: const [0.35, 0.5, 0.65],
      ).createShader(r),
      child: art,
    );

    // Thinking: gövde hafif cyan nabız atar (Opacity/ColorFiltered simülasyonu).
    body = ColorFiltered(
      colorFilter: ColorFilter.mode(
        _cyan.withValues(alpha: 0.16 * blend * (0.4 + 0.6 * pulse)),
        BlendMode.srcATop,
      ),
      child: body,
    );

    final shift = Offset(tilt.dx * w * 0.025, tilt.dy * w * 0.015); // gövde parallax

    final robot = SizedBox(
      width: w,
      height: h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (blend > 0.01) // glow
            Positioned(
              left: -w * 0.1,
              right: -w * 0.1,
              top: h * 0.02,
              height: w * 1.2,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    _cyan.withValues(alpha: 0.30 * blend * (0.5 + 0.5 * pulse)),
                    _cyan.withValues(alpha: 0),
                  ]),
                ),
              ),
            ),
          Transform.translate(offset: shift, child: body),
          if (widget.headAsset != null)
            Transform.translate(
              offset: Offset(tilt.dx * w * 0.06, tilt.dy * w * 0.035),
              child: Image.asset(widget.headAsset!, width: w, height: h, fit: BoxFit.contain),
            ),
          if (blend > 0.01) // düşünme yüzü
            Positioned(
              left: w * widget.faceRect.left + shift.dx,
              top: h * widget.faceRect.top + shift.dy,
              width: w * widget.faceRect.width,
              height: h * widget.faceRect.height,
              child: CustomPaint(
                painter: Bot82ThinkingFacePainter(_think.value, blend),
              ),
            ),
        ],
      ),
    );

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Center(
            child: Transform.translate(
              offset: Offset(-tilt.dx * w * 0.07, 0),
              child: Transform.scale(
                scale: shadowScale,
                child: CustomPaint(
                  size: Size(w * 0.62, w * 0.12),
                  painter: _ShadowPainter(shadowOpacity),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: w * 0.06,
          child: Transform.translate(
            offset: Offset(0, floatY + jumpY),
            child: Transform(
              alignment: Alignment.bottomCenter,
              transform: Matrix4.diagonal3Values(scaleX, scaleY, 1),
              child: Transform(
                alignment: Alignment.center,
                transform: perspective,
                child: robot,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ShadowPainter extends CustomPainter {
  const _ShadowPainter(this.opacity);
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2;
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(1, size.height / size.width);
    canvas.drawCircle(
      Offset.zero,
      r,
      Paint()
        ..shader = RadialGradient(colors: [
          Colors.black.withValues(alpha: opacity),
          Colors.black.withValues(alpha: 0),
        ]).createShader(Rect.fromCircle(center: Offset.zero, radius: r)),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ShadowPainter old) => old.opacity != opacity;
}

/// Bot82'nin ekranında "düşünüyorum" yüzü: sırayla parlayan 3 nokta.
class Bot82ThinkingFacePainter extends CustomPainter {
  const Bot82ThinkingFacePainter(this.phase, this.blend);
  final double phase;
  final double blend;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
        Offset.zero & size, Radius.circular(size.height * 0.28));
    canvas.drawRRect(
        rrect, Paint()..color = const Color(0xFF05080C).withValues(alpha: blend));

    final gap = size.width * 0.22;
    for (var i = 0; i < 3; i++) {
      final s = 0.5 + 0.5 * math.sin(2 * math.pi * (phase - i * 0.16));
      final c = Offset(size.width / 2 + (i - 1) * gap, size.height / 2);
      final r = size.height * (0.075 + 0.045 * s);
      canvas.drawCircle(
          c, r * 2.2, Paint()..color = _cyan.withValues(alpha: 0.18 * s * blend));
      canvas.drawCircle(c, r,
          Paint()..color = _cyan.withValues(alpha: (0.45 + 0.55 * s) * blend));
    }
  }

  @override
  bool shouldRepaint(Bot82ThinkingFacePainter old) =>
      old.phase != phase || old.blend != blend;
}
