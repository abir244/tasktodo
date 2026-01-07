
// lib/features/auth/view/forgot_email_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/widgets/dark_gradient_scaffold.dart';
import '../../../common/widgets/primary_button.dart';
import '../viewmodel/forgot_password_notifier.dart';
import '../../../main.dart';

class ForgotEmailScreen extends ConsumerWidget {
  const ForgotEmailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(forgotPasswordProvider);
    final notifier = ref.read(forgotPasswordProvider.notifier);

    final emailController = TextEditingController(
      text: state.destinationType == DestinationType.email
          ? state.destinationValue
          : '',
    );

    return DarkGradientScaffold(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20), // Figma spacing
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Top headings


          const SizedBox(height: 40),

          // ===========================
          //      3-SHADE LOGO GLOW
          // ===========================
          Center(
            child: SizedBox(
              width: 140,
              height: 140,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 1) Outer glow — very soft & wide
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFEDDF99).withOpacity(0.10),
                    ),
                  ),
                  // 2) Inner glow — medium intensity
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFEDDF99).withOpacity(0.36),
                    ),
                  ),
                  // 3) Core — solid circle with icon
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFEDDF99),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/smslogo.png',
                        width: 36,
                        height: 36,
                        color: Colors.black, // high contrast
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),
          const Text(
            'Forgot Password',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Enter Your Email',
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),

          const SizedBox(height: 40),

          // Email input
          _darkTextField(
            controller: emailController,
            hint: 'abir.molla@example.com',
          ),

          const SizedBox(height: 24),

          // Send Code button
          PrimaryButton(
            text: 'Send Code',
            loading: state.isLoading,
            onPressed: () async {
              final email = emailController.text.trim();
              final ok = await notifier.sendEmailCode(email);
              if (ok && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Code sent to your email (demo: 123456)'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                Navigator.pushNamed(context, MyApp.routeVerifyEmail);
              }
            },
          ),

          if (state.errorMessage != null) ...[
            const SizedBox(height: 14),
            Text(
              state.errorMessage!,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ],

          const SizedBox(height: 24),

          // Switch to phone recovery
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, MyApp.routeForgotPhone);
              },
              child: const Text(
                'Want to choose another way? Use Phone Number',
                style: TextStyle(
                  color: Color(0xFFEDDF99),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable dark text field
  Widget _darkTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF131318),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

