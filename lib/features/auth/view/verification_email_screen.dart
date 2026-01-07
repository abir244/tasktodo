
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/widgets/dark_gradient_scaffold.dart';
import '../../../common/widgets/primary_button.dart';
import '../../../common/widgets/otp_boxes.dart';
import '../viewmodel/forgot_password_notifier.dart';
import '../viewmodel/otp_verification_notifier.dart';
import '../../../main.dart';

class VerificationEmailScreen extends ConsumerStatefulWidget {
  const VerificationEmailScreen({super.key});

  @override
  ConsumerState<VerificationEmailScreen> createState() => _VerificationEmailScreenState();
}

class _VerificationEmailScreenState extends ConsumerState<VerificationEmailScreen> {
  @override
  Widget build(BuildContext context) {
    final forgotState = ref.watch(forgotPasswordProvider);
    final otpState = ref.watch(otpVerificationProvider);
    final otpNotifier = ref.read(otpVerificationProvider.notifier);

    return DarkGradientScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          const Text('Verification',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          const Text('Please Verify Your Email', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 6),
          const Text('Enter the 6-digit code sent to your email',
              style: TextStyle(color: Colors.white54)),
          const SizedBox(height: 20),

          const SizedBox(height: 8),
          Center(
            child: Container(
              width: 64, height: 64,
              decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Color(0xFFEDDF99),
              ),
              child: const Icon(Icons.lock_open, color: Colors.black),
            ),
          ),
          const SizedBox(height: 20),

          OtpBoxes(
            length: 6,
            onChanged: otpNotifier.updateDigit,
          ),

          const SizedBox(height: 24),
          PrimaryButton(
            text: 'Verify',
            loading: otpState.isLoading,
            onPressed: () async {
              final ok = await otpNotifier.verify();
              if (ok && mounted) {
                // Next: Phone step
                Navigator.pushNamed(context, MyApp.routeForgotPhone);
              } else if (otpState.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(otpState.errorMessage!)),
                );
              }
            },
          ),

          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: otpState.secondsLeft == 0 ? otpNotifier.resend : null,
              child: Text(
                otpState.secondsLeft == 0
                    ? 'Resend Code'
                    : 'Resend in ${otpState.secondsLeft}s',
                style: const TextStyle(
                    color: Color(0xFFEDDF99), fontWeight: FontWeight.w600),
              ),
            ),
          ),

          if (forgotState.destinationValue.isNotEmpty) ...[
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Sent to: ${forgotState.destinationValue}',
                style: const TextStyle(color: Colors.white38),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
