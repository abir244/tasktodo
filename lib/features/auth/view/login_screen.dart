
// lib/features/auth/view/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/login_notifier.dart';

// ✅ import MyApp to access route names
import '../../../main.dart';

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

    // Listen for error messages and show a snackbar
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
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFEDDF99),
                    ),
                    child: const Icon(Icons.lightbulb, color: Colors.black, size: 20),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Login to your account to explore about our app',
                  style: TextStyle(color: Colors.white70),
                ),

                const SizedBox(height: 24),

                _label('Email Address'),
                _darkField(
                  initialValue: state.email,
                  hint: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: notifier.updateEmail,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (!state.isEmailValid) return 'Enter a valid email';
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                _label('Password'),
                _darkPasswordField(
                  initialValue: state.password,
                  hint: 'Enter your password',
                  obscureText: state.obscurePassword,
                  onChanged: notifier.updatePassword,
                  onToggleObscure: notifier.toggleObscure,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (v.trim().length < 6) return 'Minimum 6 characters';
                    return null;
                  },
                ),

                const SizedBox(height: 24),

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
                        // ✅ Navigate on success (example)
                        // Navigator.pushReplacementNamed(context, MyApp.routeOnboarding);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Logged in successfully'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
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

                const SizedBox(height: 16),

                Center(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.white70),
                      ),
                      GestureDetector(
                        onTap: () {
                          // ✅ Route to register screen via centralized route
                          Navigator.pushNamed(context, MyApp.routeRegister);
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            color: Color(0xFFEDDF99),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // UI helpers
  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
    ),
  );

  Widget _darkField({
    required String initialValue,
    required String hint,
    required ValueChanged<String> onChanged,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF131318),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        validator: validator,
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

  Widget _darkPasswordField({
    required String initialValue,
    required String hint,
    required bool obscureText,
    required ValueChanged<String> onChanged,
    required VoidCallback onToggleObscure,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF131318),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        validator: validator,
        obscureText: obscureText,
        autocorrect: false,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.white70,
            ),
            onPressed: onToggleObscure,
          ),
        ),
      ),
    );
  }
}
