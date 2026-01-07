
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/widgets/dark_gradient_scaffold.dart';
import '../../../common/widgets/primary_button.dart';
import '../viewmodel/reset_password_notifier.dart';
import '../../../main.dart';

class CreateNewPasswordScreen extends ConsumerWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(resetPasswordProvider);
    final notifier = ref.read(resetPasswordProvider.notifier);

    return DarkGradientScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          const Text('Forgot Password',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          const Text('Create a New Password', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 20),

          _darkPasswordField(
            hint: 'New Password',
            value: state.newPassword,
            obscureText: state.obscureNew,
            onChanged: notifier.updateNew,
            onToggleObscure: notifier.toggleObscureNew,
          ),
          const SizedBox(height: 12),
          _darkPasswordField(
            hint: 'Confirm New Password',
            value: state.confirmPassword,
            obscureText: state.obscureConfirm,
            onChanged: notifier.updateConfirm,
            onToggleObscure: notifier.toggleObscureConfirm,
          ),

          const SizedBox(height: 20),
          PrimaryButton(
            text: 'Submit',
            loading: state.isLoading,
            onPressed: state.canSubmit
                ? () async {
              final ok = await notifier.submit();
              if (ok && context.mounted) {
                Navigator.pushReplacementNamed(context, MyApp.routeResetSuccess);
              } else if (state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage!)),
                );
              }
            }
                : null,
          ),

          if (state.errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(state.errorMessage!, style: const TextStyle(color: Colors.redAccent)),
          ],
        ],
      ),
    );
  }

  Widget _darkPasswordField({
    required String hint,
    required String value,
    required bool obscureText,
    required ValueChanged<String> onChanged,
    required VoidCallback onToggleObscure,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF131318),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: TextField(
        onChanged: onChanged,
        obscureText: obscureText,
        autocorrect: false,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.white70),
            onPressed: onToggleObscure,
          ),
        ),
      ),
    );
  }
}
