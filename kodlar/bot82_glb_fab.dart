import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import '../chat_screen.dart'; // ChatbotScreen (yolu projene göre düzelt)

// ---------------------------------------------------------------------------
// Global durum / yardımcılar
// ---------------------------------------------------------------------------

/// GoRouter'a `navigatorKey: rootNavigatorKey` olarak ver.
final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Sohbet sheet'i açıkken Bot82 gizlenir.
final ValueNotifier<bool> bot82ChatOpen = ValueNotifier(false);

Future<void> openBot82Chat() async {
  final ctx = rootNavigatorKey.currentContext;
  if (ctx == null || bot82ChatOpen.value) return;
  bot82ChatOpen.value = true;
  try {
    await showModalBottomSheet<void>(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      sheetAnimationStyle: const AnimationStyle(
        duration: Duration(milliseconds: 480),
        reverseDuration: Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(sheetCtx).bottom),
        child: Container(
          height: MediaQuery.sizeOf(sheetCtx).height * 0.6,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: const ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            child: ChatbotScreen(isMini: true),
          ),
        ),
      ),
    );
  } finally {
    bot82ChatOpen.value = false;
  }
}

// ---------------------------------------------------------------------------
// Ortak 3D model widget'ı (FAB ve sohbet avatarı aynı ayarları kullanır)
// ---------------------------------------------------------------------------

Widget _bot82Model(String asset) => ModelViewer(
      src: asset,
      alt: 'Bot82 asistan',
      backgroundColor: Colors.transparent,
      ar: false,
      autoRotate: false,
      cameraControls: false,
      disableZoom: true,
      interactionPrompt: InteractionPrompt.none,
      // theta phi radius: 0deg = tam karşıdan; yarıçapı % ile uzaklaştır/yaklaştır.
      cameraOrbit: '0deg 80deg 110%',
      shadowIntensity: 0, // gölgeyi Flutter tarafında çiziyoruz
      exposure: 1.1,
      loading: Loading.eager,
      reveal: Reveal.auto,
    );

// ---------------------------------------------------------------------------
// 3D model FAB
// ---------------------------------------------------------------------------

class Bot82ModelFab extends StatefulWidget {
  const Bot82ModelFab({
    super.key,
    required this.onTap,
    this.size = 88,
    this.modelAsset = 'assets/models/bot82.glb',
  });

  final VoidCallback onTap;

  /// Genişlik (px). Yükseklik buna göre hesaplanır.
  final double size;
  final String modelAsset;

  @override
  State<Bot82ModelFab> createState() => _Bot82ModelFabState();
}

class _Bot82ModelFabState extends State<Bot82ModelFab>
    with TickerProviderStateMixin {
  late final AnimationController _float;

  /// Basılma ölçeği (1.0 = normal). Unbounded: spring overshoot yapabilsin.
  late final AnimationController _press;

  /// WebView bir kez kurulur; animasyon karelerinde yeniden oluşturulmaz.
  late final Widget _model = RepaintBoundary(
    // WebView dokunuşları yutar; tüm dokunuşları Flutter tarafı yönetsin.
    child: IgnorePointer(child: _bot82Model(widget.modelAsset)),
  );

  double get _h => widget.size * 1.3;

  @override
  void initState() {
    super.initState();
    _float = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true); // sonsuz yukarı-aşağı
    _press = AnimationController.unbounded(vsync: this, value: 1.0);
  }

  @override
  void dispose() {
    _float.dispose();
    _press.dispose();
    super.dispose();
  }

  void _pressDown() {
    _press.animateTo(
      0.86,
      duration: const Duration(milliseconds: 90),
      curve: Curves.easeOut,
    );
  }

  void _release() {
    const spring = SpringDescription(mass: 1, stiffness: 380, damping: 11);
    _press.animateWith(SpringSimulation(spring, _press.value, 1.0, 0.0));
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    // Bounce görünsün, sonra aksiyon.
    Future.delayed(const Duration(milliseconds: 140), () {
      if (mounted) widget.onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.size;
    final h = _h;
    final shadowH = w * 0.14;
    final amp = w * 0.045;

    return Semantics(
      button: true,
      label: 'Bot82 asistan, sohbeti aç',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _pressDown(),
        onTapUp: (_) => _release(),
        onTapCancel: _release,
        onTap: _handleTap,
        child: SizedBox(
          width: w,
          height: h + shadowH,
          child: AnimatedBuilder(
            animation: Listenable.merge([_float, _press]),
            child: _model,
            builder: (context, model) {
              final t = Curves.easeInOutSine.transform(_float.value); // 0..1
              final dy = -(t * 2 - 1) * amp; // -amp..+amp
              final scale = _press.value;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // Zemin gölgesi: bot yükselince küçülür ve silikleşir.
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Center(
                      child: Transform.scale(
                        scale: 1 - 0.18 * t,
                        child: CustomPaint(
                          size: Size(w * 0.55, shadowH),
                          painter: _ShadowPainter(0.30 - 0.12 * t),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    height: h,
                    child: Transform.translate(
                      offset: Offset(0, dy),
                      child: Transform.scale(
                        scale: scale,
                        alignment: Alignment.bottomCenter,
                        child: model,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
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

// ---------------------------------------------------------------------------
// Tüm sayfaların üstünde sağ-alt FAB
// ---------------------------------------------------------------------------

/// MaterialApp.router(builder: (c, child) => Bot82GlbOverlay(child: child!))
class Bot82GlbOverlay extends StatelessWidget {
  const Bot82GlbOverlay({
    super.key,
    required this.child,
    this.bottomOffset = 82, // AppShell alt bar (70) + boşluk
    this.rightOffset = 8,
    this.keepAliveWhileChatOpen = false,
  });

  final Widget child;
  final double bottomOffset;
  final double rightOffset;

  /// false: sohbet açıkken FAB'ın WebView'i kapatılır (bellek tasarrufu; kapanınca
  /// model yeniden yüklenir). true: arka planda canlı kalır.
  final bool keepAliveWhileChatOpen;

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.viewInsetsOf(context).bottom > 0;
    final safeBottom = MediaQuery.paddingOf(context).bottom;

    // builder, Navigator'ın üstünde olduğu için Material'i kendimiz sağlıyoruz.
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          child,
          Positioned(
            right: rightOffset,
            bottom: safeBottom + bottomOffset,
            // fab `child` olarak verildi: open değişince WebView yeniden kurulmaz.
            child: ValueListenableBuilder<bool>(
              valueListenable: bot82ChatOpen,
              child: Bot82ModelFab(onTap: openBot82Chat),
              builder: (context, open, fab) {
                if (open && !keepAliveWhileChatOpen) return const SizedBox.shrink();
                final hidden = open || keyboard;
                return IgnorePointer(
                  ignoring: hidden,
                  child: AnimatedScale(
                    scale: hidden ? 0.0 : 1.0,
                    alignment: Alignment.bottomRight,
                    duration: Duration(milliseconds: hidden ? 160 : 400),
                    curve: hidden ? Curves.easeIn : Curves.easeOutBack,
                    child: fab,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sohbet ekranı: sohbet balonlarının yanında duran canlı Bot82
// ---------------------------------------------------------------------------

/// Dokunmasız, küçük canlı avatar: süzülür; [thinking] true iken kalp atışı gibi nabız atar.
class Bot82LiveAvatar extends StatefulWidget {
  const Bot82LiveAvatar({
    super.key,
    this.size = 52,
    this.thinking = false,
    this.modelAsset = 'assets/models/bot82.glb',
  });

  final double size;
  final bool thinking;
  final String modelAsset;

  @override
  State<Bot82LiveAvatar> createState() => _Bot82LiveAvatarState();
}

class _Bot82LiveAvatarState extends State<Bot82LiveAvatar>
    with TickerProviderStateMixin {
  late final AnimationController _float;
  late final AnimationController _beat;

  late final Widget _model = RepaintBoundary(
    child: IgnorePointer(child: _bot82Model(widget.modelAsset)),
  );

  @override
  void initState() {
    super.initState();
    _float = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _beat = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    if (widget.thinking) _beat.repeat();
  }

  @override
  void didUpdateWidget(Bot82LiveAvatar old) {
    super.didUpdateWidget(old);
    if (widget.thinking != old.thinking) {
      if (widget.thinking) {
        _beat.repeat();
      } else {
        _beat
          ..stop()
          ..value = 0;
      }
    }
  }

  @override
  void dispose() {
    _float.dispose();
    _beat.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.size;
    return SizedBox(
      width: w,
      height: w * 1.3,
      child: AnimatedBuilder(
        animation: Listenable.merge([_float, _beat]),
        child: _model,
        builder: (context, model) {
          final t = Curves.easeInOutSine.transform(_float.value);
          final dy = -(t * 2 - 1) * w * 0.04;
          final pulse = widget.thinking
              ? 0.5 + 0.5 * math.sin(2 * math.pi * _beat.value)
              : 0.0;
          return Transform.translate(
            offset: Offset(0, dy),
            child: Transform.scale(
              scale: 1 + 0.08 * pulse,
              alignment: Alignment.bottomCenter,
              child: model,
            ),
          );
        },
      ),
    );
  }
}

/// Mesaj listesini sararsın; Bot82 sol altta, en yeni bot balonlarının yanında durur.
/// Tek bir WebView kullanır (her mesaja ayrı 3D model koymak çok ağır olur).
///
///   Bot82ChatStage(
///     thinking: isLoading,
///     child: ListView.builder(...),   // sadece mesaj listesi, giriş alanı değil
///   )
class Bot82ChatStage extends StatelessWidget {
  const Bot82ChatStage({
    super.key,
    required this.child,
    this.thinking = false,
    this.avatarSize = 52,
  });

  final Widget child;
  final bool thinking;
  final double avatarSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Balonlar avatarın üstüne binmesin diye sol boşluk bırak.
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.only(left: avatarSize + 8),
            child: child,
          ),
        ),
        Positioned(
          left: 4,
          bottom: 4,
          child: Bot82LiveAvatar(size: avatarSize, thinking: thinking),
        ),
      ],
    );
  }
}
