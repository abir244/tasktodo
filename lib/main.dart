
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Features
import 'features/splash/view/splash_screen.dart';
import 'features/onboarding/view/onboarding_screen.dart';
import 'features/auth/view/register_screen.dart';
import 'features/documents/view/select_document_type_screen.dart';
// If you also want to deep-link other steps, you can add:
// import 'features/documents/view/scan_id_card_screen.dart';
// import 'features/documents/view/confirm_identity_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Centralized route names
  static const String routeSplash = '/';
  static const String routeOnboarding = '/onboarding';
  static const String routeRegister = '/register';
  static const String routeDocType = '/doc-type';
  // static const String routeScanId = '/scan-id';
  // static const String routeConfirmIdentity = '/confirm-identity';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Initial route
      initialRoute: routeSplash,

      // Dark theme to match your UI
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D12),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFC107), // amber
          surface: Color(0xFF121219),
          onSurface: Colors.white,
        ),
        useMaterial3: false,
      ),

      // Centralized route factory with fade transition
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case routeSplash:
            return _fade(const SplashScreen());
          case routeOnboarding:
            return _fade(const OnboardingScreen());
          case routeRegister:
            return _fade(const RegisterScreen());
          case routeDocType:
            return _fade(const SelectDocumentTypeScreen());

        // If you add more screens later:
        // case routeScanId:
        //   return _fade(const ScanIdCardScreen());
        // case routeConfirmIdentity:
        //   return _fade(const ConfirmIdentityScreen());

          default:
          // Fallback
            return _fade(const SplashScreen());
        }
      },
    );
  }

  /// Nicer page transition
  static PageRoute _fade(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => child,
      transitionsBuilder: (context, anim, secondaryAnim, widget) {
        return FadeTransition(opacity: anim, child: widget);
      },
      transitionDuration: const Duration(milliseconds: 200),
    );
  }
}
