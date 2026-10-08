import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.light;

  void toggle() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(() => ThemeModeNotifier());

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => const Locale('tr');

  void toggle() {
    state = state.languageCode == 'tr' ? const Locale('en') : const Locale('tr');
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(() => LocaleNotifier());

class TextSizeNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() {
    state = !state;
  }
}

final textSizeProvider = NotifierProvider<TextSizeNotifier, bool>(() => TextSizeNotifier());
