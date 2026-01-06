
// lib/screens/email_otp_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ✅ fix the path (no space)
import '../ viewmodel/verification_notifier.dart';


// ✅ import MyApp route names
import '../../../main.dart';


class EmailOtpScreen extends ConsumerWidget {
  const EmailOtpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(verificationProvider);
    final notifier = ref.read(verificationProvider.notifier);

    // Listen for errors and show a snackbar (e.g., failed verify/resend)
    ref.listen<VerificationState>(verificationProvider, (prev, next) {
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    final isVerifying = state.isVerifying; // from upgraded notifier

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D12),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                height: 80,
                width: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFFEDDF99),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.mail, size: 36, color: Colors.black),
              ),
              const SizedBox(height: 24),

              const Text(
                'Please Verify Your Email',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              Text(
                'Enter the 5-digit code we sent by email to ${state.email.isEmpty ? 'your email' : state.email}',
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              _OtpBoxes(
                length: 5,
                value: state.code,
                onChanged: notifier.updateCode,
              ),

              const Spacer(),

              // Verify button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: state.isButtonEnabled && !isVerifying
                        ? const Color(0xFFEDDF99)
                        : Colors.grey.shade800,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: (state.isButtonEnabled && !isVerifying)
                      ? () async {
                    // 🔹 Shortcut: accept fake OTP "12345" and route to login
                    if (state.code == '12345') {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Email verified (demo 12345).'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      // Clear the stack and go to Login
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        MyApp.routeLogin,
                            (route) => false,
                      );
                      return;
                    }

                    // 🔹 Otherwise use the notifier (real verification)
                    final ok = await notifier.verify();
                    if (!context.mounted) return;
                    if (ok) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Email verified successfully!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        MyApp.routeLogin,
                            (route) => false,
                      );
                    }
                    // On failure, error message is shown via ref.listen above
                  }
                      : null,
                  child: isVerifying
                      ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text('Verify', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),

              const SizedBox(height: 16),

              // Resend
              TextButton(
                onPressed: (state.resendSeconds == 0 && !state.isSending)
                    ? notifier.resendCode
                    : null,
                child: Text(
                  state.resendSeconds == 0
                      ? 'Didn’t receive the code? Resend Code'
                      : 'Resend in ${state.resendSeconds}s',
                  style: const TextStyle(color: Color(0xFFEDDF99)),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpBoxes extends StatefulWidget {
  final int length;
  final String value;
  final ValueChanged<String> onChanged;

  const _OtpBoxes({
    required this.length,
    required this.value,
    required this.onChanged,
  });

  @override
  State<_OtpBoxes> createState() => _OtpBoxesState();
}

class _OtpBoxesState extends State<_OtpBoxes> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _nodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _nodes = List.generate(widget.length, (_) => FocusNode());
    _syncControllers(widget.value);
  }

  @override
  void didUpdateWidget(covariant _OtpBoxes oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _syncControllers(widget.value);
    }
  }

  void _syncControllers(String value) {
    final chars = value.split('');
    for (int i = 0; i < widget.length; i++) {
      final text = i < chars.length ? chars[i] : '';
      _controllers[i].value = TextEditingValue(text: text);
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const boxWidth = 48.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (i) {
        return SizedBox(
          width: boxWidth,
          child: TextField(
            controller: _controllers[i],
            focusNode: _nodes[i],
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: const InputDecoration(
              counterText: '',
              filled: true,
              fillColor: Color(0xFF131318),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF3A3A3A)),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFEDDF99)),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            onChanged: (char) {
              final digit = char.replaceAll(RegExp(r'\D'), '');
              _controllers[i].text = digit;
              _controllers[i].selection = TextSelection.collapsed(offset: digit.length);

              final buffer = StringBuffer();
              for (int j = 0; j < widget.length; j++) {
                final t = _controllers[j].text;
                buffer.write(t.isNotEmpty ? t[0] : '');
              }
              final newValue = buffer.toString();
              widget.onChanged(newValue);

              if (digit.isNotEmpty && i < widget.length - 1) {
                _nodes[i + 1].requestFocus();
              } else if (digit.isEmpty && i > 0) {
                _nodes[i - 1].requestFocus();
              }
            },
            onSubmitted: (_) {
              if (i < widget.length - 1) {
                _nodes[i + 1].requestFocus();
              }
            },
          ),
        );
      }),
    );
  }
}
