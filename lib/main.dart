import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import ' features/onboarding/view/onboarding_screen.dart';
import ' features/splash/view/splash_screen.dart';


void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      /// Initial route
      initialRoute: '/',

      /// App routes
      routes: {
        '/': (_) => const SplashScreen(),
        '/onboarding': (_) => const OnboardingScreen(),

      },
    );
  }
}
