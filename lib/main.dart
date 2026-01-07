
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

// ===== Existing Features =====
import 'features/splash/view/splash_screen.dart';
import 'features/onboarding/view/onboarding_screen.dart';
import 'features/auth/view/register_screen.dart';
import 'features/auth/view/login_screen.dart';
import 'features/documents/view/select_document_type_screen.dart';
import 'features/verification/view/complete_profile_screen.dart';
import 'features/verification/view/email_otp_screen.dart';

// ===== New Forgot/OTP/Reset Flow =====
import 'features/auth/view/forgot_email_screen.dart';
import 'features/auth/view/verification_email_screen.dart';
import 'features/auth/view/forgot_phone_screen.dart';
import 'features/auth/view/verification_phone_screen.dart';
import 'features/auth/view/create_new_password_screen.dart';
import 'features/auth/view/password_reset_success_screen.dart';

// ===== NEW LOCATION FEATURE =====
import 'features/location/view/choose_location_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //  Centralized route names
  static const String routeSplash = '/';
  static const String routeOnboarding = '/onboarding';
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeDocType = '/doc-type';
  static const String routeVerifyProfile = '/verify-profile';
  static const String routeVerifyOtp = '/verify-otp';

  //  Forgot/Reset routes
  static const String routeForgotEmail = '/forgot-email';
  static const String routeVerifyEmail = '/verify-email';
  static const String routeForgotPhone = '/forgot-phone';
  static const String routeVerifyPhone = '/verify-phone';
  static const String routeCreateNewPassword = '/create-new-password';
  static const String routeResetSuccess = '/reset-success';

  // NEW: Choose location
  static const String routeChooseLocation = '/choose-location';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // ✅ Keep ONLY this
      initialRoute: routeSplash,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D12),
      ),

      onGenerateRoute: (settings) {
        switch (settings.name) {

        // ---- Core Flow ----
          case routeSplash:
            return _fade(const SplashScreen());
          case routeOnboarding:
            return _fade(const OnboardingScreen());
          case routeLogin:
            return _fade(const LoginScreen());
          case routeRegister:
            return _fade(const RegisterScreen());
          case routeDocType:
            return _fade(const SelectDocumentTypeScreen());
          case routeVerifyProfile:
            return _fade(const CompleteProfileScreen());
          case routeVerifyOtp:
            return _fade(const EmailOtpScreen());

        // ---- Forgot/Reset ----
          case routeForgotEmail:
            return _fade(const ForgotEmailScreen());
          case routeVerifyEmail:
            return _fade(const VerificationEmailScreen());
          case routeForgotPhone:
            return _fade(const ForgotPhoneScreen());
          case routeVerifyPhone:
            return _fade(const VerificationPhoneScreen());
          case routeCreateNewPassword:
            return _fade(const CreateNewPasswordScreen());
          case routeResetSuccess:
            return _fade(const PasswordResetSuccessScreen());

        // ---- LOCATION MAP ----
          case routeChooseLocation:
            return _fade(const ChooseLocationScreen());

        // ---- Fallback ----
          default:
            return _fade(const SplashScreen());
        }
      },
    );
  }

  /// Fade transition
  static PageRoute<dynamic> _fade(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => child,
      transitionsBuilder: (_, anim, __, widget) =>
          FadeTransition(opacity: anim, child: widget),
      transitionDuration: const Duration(milliseconds: 200),
    );
  }
}
