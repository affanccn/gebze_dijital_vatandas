import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gebze_dijital_vatandas/app/config/settings_provider.dart';
import 'package:gebze_dijital_vatandas/app/router/app_router.dart';
import 'package:gebze_dijital_vatandas/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:gebze_dijital_vatandas/features/chatbot/presentation/widgets/bot82_overlay.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      print('=== FLUTTER ERROR ===');
      print(details.exceptionAsString());
      print(details.stack);
      return Container(
        color: Colors.black87,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            '${details.exceptionAsString()}\n\n${details.stack}',
            style: const TextStyle(color: Colors.red, fontSize: 12),
            textDirection: TextDirection.ltr,
          ),
        ),
      );
    };

    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      builder: (context, child) => Bot82Overlay(child: child ?? const SizedBox.shrink()),
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      themeMode: themeMode,
      locale: locale,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D253F),
          primary: const Color(0xFF0D253F),
          secondary: const Color(0xFF00B4D8),
          tertiary: const Color(0xFFFF7A00),
          surface: const Color(0xFFF7F8FA),
          error: const Color(0xFFE53935),
        ),
        fontFamily: GoogleFonts.poppins().fontFamily,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D253F),
          foregroundColor: Colors.white,
          centerTitle: false,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF7A00),
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF00B4D8),
            side: const BorderSide(color: Color(0xFF00B4D8)),
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xFF00B4D8),
          primary: const Color(0xFF00B4D8),
          secondary: const Color(0xFFFF7A00),
        ),
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('tr'),
        Locale('en'),
      ],
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
