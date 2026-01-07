
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/widgets/dark_gradient_scaffold.dart';
import '../../../common/widgets/primary_button.dart';
import '../../../common/widgets/otp_boxes.dart';
import '../viewmodel/forgot_password_notifier.dart';
import '../viewmodel/otp_verification_notifier.dart';
import '../../../main.dart';

class VerificationPhoneScreen extends ConsumerStatefulWidget {
  const VerificationPhoneScreen({super.key});

  @override
  ConsumerState<VerificationPhoneScreen> createState() => _VerificationPhoneScreenState();
}

class _VerificationPhoneScreenState extends ConsumerState<VerificationPhoneScreen> {
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
          const Text('Please Verify Your Phone Number', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 6),
          const Text('Enter the 6-digit code sent to your phone',
              style: TextStyle(color: Colors.white54)),
          const SizedBox(height: 20),

          const SizedBox(height: 8),
          Center(
            child: Container(
              width: 64, height: 64,
              decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Color(0xFFEDDF99),
              ),
              child: const Icon(Icons.phone_android, color: Colors.black),
            ),
          ),
          const SizedBox(height: 20),

          OtpBoxes(length: 6, onChanged: otpNotifier.updateDigit),

          const SizedBox(height: 24),
          PrimaryButton(
            text: 'Verify',
            loading: otpState.isLoading,
            onPressed: () async {
              final ok = await otpNotifier.verify();
              if (ok && mounted) {
                Navigator.pushNamed(context, MyApp.routeCreateNewPassword);
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

