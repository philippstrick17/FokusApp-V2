import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fokus_app_v2/providers/app_state.dart';
import 'package:fokus_app_v2/screens/home_screen.dart';

void main() {
  runApp(const FokusApp());
}

class FokusApp extends StatelessWidget {
  const FokusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FokusApp V2',
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: const Color(0xFFFAFBFF),
          primaryColor: const Color(0xFF4C6FFF),
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4C6FFF)),
          textTheme: const TextTheme(
            headlineSmall: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.5),
            titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            bodyMedium: TextStyle(fontSize: 15, height: 1.5),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
