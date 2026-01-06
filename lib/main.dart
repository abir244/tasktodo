
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

// Features
import 'features/splash/view/splash_screen.dart';
import 'features/onboarding/view/onboarding_screen.dart';
import 'features/auth/view/register_screen.dart';
import 'features/auth/view/login_screen.dart'; // ✅ add this
import 'features/documents/view/select_document_type_screen.dart';
import 'features/verification/view/complete_profile_screen.dart';
import 'features/verification/view/email_otp_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Android-only Firebase init (works if google-services.json is set)
  await Firebase.initializeApp();
  debugPrint('🔥 Firebase connected: ${Firebase.apps.isNotEmpty}');
  debugPrint('🔥 Firebase apps: ${Firebase.apps}');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // 🔹 Centralized route names
  static const String routeSplash = '/';
  static const String routeOnboarding = '/onboarding';
  static const String routeLogin = '/login';               // ✅ add
  static const String routeRegister = '/register';
  static const String routeDocType = '/doc-type';
  static const String routeVerifyProfile = '/verify-profile';
  static const String routeVerifyOtp = '/verify-otp';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: routeSplash, // keep splash as the start
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D12),
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case routeSplash:
            return _fade(const SplashScreen());
          case routeOnboarding:
            return _fade(const OnboardingScreen());
          case routeLogin: // ✅ new route
            return _fade(const LoginScreen());
          case routeRegister:
            return _fade(const RegisterScreen());
          case routeDocType:
            return _fade(const SelectDocumentTypeScreen());
          case routeVerifyProfile:
            return _fade(const CompleteProfileScreen());
          case routeVerifyOtp:
            return _fade(const EmailOtpScreen());
          default:
            return _fade(const SplashScreen());
        }
      },
    );
  }

  /// 🔹 Fade transition
  static PageRoute _fade(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => child,
      transitionsBuilder: (_, anim, __, widget) =>
          FadeTransition(opacity: anim, child: widget),
      transitionDuration: const Duration(milliseconds: 200),
    );
  }
}
