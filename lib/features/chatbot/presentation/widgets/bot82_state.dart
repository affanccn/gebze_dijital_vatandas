import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bot82'nin 3 temel animasyon durumu.
enum Bot82Mode { idle, thinking, tapped }

class Bot82State {
  const Bot82State({this.mode = Bot82Mode.idle, this.chatOpen = false});

  final Bot82Mode mode;
  final bool chatOpen;

  Bot82State copyWith({Bot82Mode? mode, bool? chatOpen}) => Bot82State(
        mode: mode ?? this.mode,
        chatOpen: chatOpen ?? this.chatOpen,
      );
}

class Bot82Notifier extends Notifier<Bot82State> {
  int _pending = 0; // aynı anda bekleyen API istekleri
  Timer? _tapTimer;

  @override
  Bot82State build() {
    ref.onDispose(() => _tapTimer?.cancel());
    return const Bot82State();
  }

  /// API isteğini sararsan thinking durumu otomatik yönetilir.
  ///   final reply = await ref.read(bot82Provider.notifier).track(() => repo.ask(q));
  Future<T> track<T>(Future<T> Function() task) async {
    beginThinking();
    try {
      return await task();
    } finally {
      endThinking();
    }
  }

  void beginThinking() {
    _pending++;
    _sync();
  }

  void endThinking() {
    if (_pending > 0) _pending--;
    _sync();
  }

  /// Tıklanma: kısa süreli `tapped`, sonra idle/thinking'e döner.
  void registerTap() {
    _tapTimer?.cancel();
    state = state.copyWith(mode: Bot82Mode.tapped);
    _tapTimer = Timer(const Duration(milliseconds: 650), _sync);
  }

  void setChatOpen(bool open) => state = state.copyWith(chatOpen: open);

  void _sync() {
    if (_tapTimer?.isActive ?? false) return; // tap bitince tekrar senkronlanır
    final next = _pending > 0 ? Bot82Mode.thinking : Bot82Mode.idle;
    if (state.mode != next) state = state.copyWith(mode: next);
  }
}

final bot82Provider =
    NotifierProvider<Bot82Notifier, Bot82State>(Bot82Notifier.new);
