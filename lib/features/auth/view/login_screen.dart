
// lib/features/auth/view/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/login_notifier.dart';
import '../../../main.dart'; // ✅ For route constants

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginProvider);
    final notifier = ref.read(loginProvider.notifier);

    ref.listen<LoginState>(loginProvider, (prev, next) {
      final msg = next.errorMessage;
      if (msg != null && msg.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ... (UI unchanged above)
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: state.canSubmit
                          ? const Color(0xFFEDDF99)
                          : Colors.grey.shade800,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    onPressed: state.canSubmit
                        ? () async {
                      final isValid = _formKey.currentState?.validate() ?? false;
                      if (!isValid) return;

                      final ok = await notifier.submit();
                      if (!mounted) return;
                      if (ok) {
                        // ✅ OPTION A: Replace current screen with map
                        Navigator.pushReplacementNamed(
                          context,
                          MyApp.routeChooseLocation,
                        );

                        // If you want a quick feedback too, you can show a short snackbar:
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(
                        //     content: Text('Logged in'),
                        //     behavior: SnackBarBehavior.floating,
                        //     duration: Duration(milliseconds: 900),
                        //   ),
                        // );
                      }
                    }
                        : null,
                    child: state.isLoading
                        ? const SizedBox(
                      height: 22, width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Text('Login', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
                // ... (rest unchanged)
              ],
            ),
          ),
        ),
      ),
    );
  }

// ... helper widgets unchanged
}
