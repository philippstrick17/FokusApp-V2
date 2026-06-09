import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:fokus_app_v2/providers/app_state.dart';
import 'package:fokus_app_v2/screens/home_screen.dart';
import 'package:fokus_app_v2/screens/onboarding_screen.dart';

void main() {
  runApp(const FokusApp());
}

class FokusApp extends StatelessWidget {
  const FokusApp({super.key});

  static const Color _lightSeed = Color(0xFF4C6FFF);
  static const Color _darkSeed = Color(0xFF7C99FF);

  ThemeData _buildLightTheme() {
    final colorScheme = ColorScheme.fromSeed(seedColor: _lightSeed, brightness: Brightness.light);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFFAFBFF),
      primaryColor: _lightSeed,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        titleTextStyle: TextStyle(color: colorScheme.onSurface, fontSize: 20, fontWeight: FontWeight.w700),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shadowColor: Colors.black.withAlpha(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF1F5FF),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) => colorScheme.primary),
        trackColor: WidgetStateProperty.resolveWith((states) => colorScheme.primary.withAlpha(90)),
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.5),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(fontSize: 15, height: 1.5),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    final colorScheme = ColorScheme.fromSeed(seedColor: _darkSeed, brightness: Brightness.dark);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      primaryColor: _darkSeed,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        titleTextStyle: TextStyle(color: colorScheme.onSurface, fontSize: 20, fontWeight: FontWeight.w700),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF111827),
        elevation: 0,
        shadowColor: Colors.black.withAlpha(24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF111827),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E293B),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) => colorScheme.primary),
        trackColor: WidgetStateProperty.resolveWith((states) => colorScheme.primary.withAlpha(90)),
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.5),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(fontSize: 15, height: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: Consumer<AppState>(
        builder: (context, appState, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'FokusApp V2',
            theme: _buildLightTheme(),
            darkTheme: _buildDarkTheme(),
            themeMode: appState.darkModeEnabled ? ThemeMode.dark : ThemeMode.light,
            home: appState.initialized
                ? (appState.onboardingComplete ? const HomeScreen() : const OnboardingScreen())
                : const Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        },
      ),
    );
  }
}
