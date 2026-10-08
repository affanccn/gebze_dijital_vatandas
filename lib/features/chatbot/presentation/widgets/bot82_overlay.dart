import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../chat_screen.dart'; // ChatbotScreen
import 'bot82_fab.dart';
import 'bot82_state.dart';

/// GoRouter'a `navigatorKey: rootNavigatorKey` olarak ver.
final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// MaterialApp.router(builder: ...) içinde kullan -> tüm ekranların üstünde durur.
class Bot82Overlay extends ConsumerStatefulWidget {
  const Bot82Overlay({
    super.key,
    required this.child,
    this.bottomOffset = 82, // AppShell alt bar (70) + boşluk
    this.rightOffset = 10,
  });

  final Widget child;
  final double bottomOffset;
  final double rightOffset;

  @override
  ConsumerState<Bot82Overlay> createState() => _Bot82OverlayState();
}

class _Bot82OverlayState extends ConsumerState<Bot82Overlay> {
  bool _bubble = false;
  Timer? _showT, _hideT;

  @override
  void initState() {
    super.initState();
    _showT = Timer(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      setState(() => _bubble = true);
      _hideT = Timer(const Duration(seconds: 5), () {
        if (mounted) setState(() => _bubble = false);
      });
    });
  }

  @override
  void dispose() {
    _showT?.cancel();
    _hideT?.cancel();
    super.dispose();
  }

  Future<void> _openChat() async {
    final ctx = rootNavigatorKey.currentContext;
    if (ctx == null) return;
    final notifier = ref.read(bot82Provider.notifier);

    setState(() => _bubble = false);
    notifier.setChatOpen(true);

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

    // Sheet kapanınca Bot82 geri "pop" ile gelir.
    notifier.setChatOpen(false);
  }

  @override
  Widget build(BuildContext context) {
    final chatOpen = ref.watch(bot82Provider.select((s) => s.chatOpen));
    final keyboard = MediaQuery.viewInsetsOf(context).bottom > 0;
    final hidden = chatOpen || keyboard;
    final safeBottom = MediaQuery.paddingOf(context).bottom;

    // builder Navigator'ın üstünde olduğu için Material/Directionality kendimiz sağlıyoruz.
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          widget.child,
          Positioned(
            right: widget.rightOffset,
            bottom: safeBottom + widget.bottomOffset,
            child: IgnorePointer(
              ignoring: hidden,
              child: AnimatedScale(
                scale: hidden ? 0.0 : 1.0,
                duration: Duration(milliseconds: hidden ? 180 : 420),
                curve: hidden ? Curves.easeIn : Curves.easeOutBack,
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (c, a) => FadeTransition(
                        opacity: a,
                        child: ScaleTransition(
                            scale: a, alignment: Alignment.bottomRight, child: c),
                      ),
                      child: _bubble
                          ? GestureDetector(
                              key: const ValueKey('bubble'),
                              onTap: _openChat,
                              child: const _GreetingBubble(),
                            )
                          : const SizedBox.shrink(key: ValueKey('none')),
                    ),
                    Bot82Fab(onTap: _openChat),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GreetingBubble extends StatelessWidget {
  const _GreetingBubble();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30, right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Text(
        'Nasıl yardımcı\nolabilirim?',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: Color(0xFF0D253F),
        ),
      ),
    );
  }
}
