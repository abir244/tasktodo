
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/widgets/dark_gradient_scaffold.dart';
import '../../../common/widgets/primary_button.dart';
import '../viewmodel/forgot_password_notifier.dart';
import '../../../main.dart';

class ForgotPhoneScreen extends ConsumerWidget {
  const ForgotPhoneScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(forgotPasswordProvider);
    final notifier = ref.read(forgotPasswordProvider.notifier);

    final ccController = TextEditingController(text: '+');
    final phoneController = TextEditingController();

    return DarkGradientScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          const Text('Forgot Password',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          const Text('Enter Your Phone Number', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                flex: 3,
                child: _darkField(
                  controller: ccController,
                  hint: '+Country Code',
                  keyboardType: TextInputType.phone,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 7,
                child: _darkField(
                  controller: phoneController,
                  hint: 'Phone number',
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          PrimaryButton(
            text: 'Send Code',
            loading: state.isLoading,
            onPressed: () async {
              final full = '${ccController.text}${phoneController.text}';
              final ok = await notifier.sendPhoneCode(full);
              if (ok && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Code sent to your phone (demo: 123456)'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                Navigator.pushNamed(context, MyApp.routeVerifyPhone);
              }
            },
          ),

          if (state.errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(state.errorMessage!, style: const TextStyle(color: Colors.redAccent)),
          ],

          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pushNamed(context, MyApp.routeForgotEmail),
              child: const Text('Want to choose another way? Use Email',
                  style: TextStyle(color: Color(0xFFEDDF99), fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _darkField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF131318),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        autocorrect: false,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
