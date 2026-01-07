
import 'package:flutter/material.dart';
import '../../../common/widgets/dark_gradient_scaffold.dart';
import '../../../common/widgets/primary_button.dart';
import '../../../main.dart';

class PasswordResetSuccessScreen extends StatelessWidget {
  const PasswordResetSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DarkGradientScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          Center(
            child: Container(
              width: 88, height: 88,
              decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Color(0xFFEDDF99),
              ),
              child: const Icon(Icons.check, color: Colors.black, size: 36),
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text('Congratulations!',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 6),
          const Center(
            child: Text('Your password has been successfully updated',
                style: TextStyle(color: Colors.white70)),
          ),
          const SizedBox(height: 28),
          PrimaryButton(
            text: 'Back to Login',
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, MyApp.routeLogin, (route) => false),
          ),
        ],
      ),
    );
  }
}
