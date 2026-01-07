
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'forgot_password_notifier.dart';

class OtpVerificationState {
  final bool isLoading;
  final String? errorMessage;
  final String code;       // user input
  final bool verified;
  final int secondsLeft;   // for resend countdown (optional)

  OtpVerificationState({
    this.isLoading = false,
    this.errorMessage,
    this.code = '',
    this.verified = false,
    this.secondsLeft = 0,
  });

  OtpVerificationState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? code,
    bool? verified,
    int? secondsLeft,
  }) {
    return OtpVerificationState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      code: code ?? this.code,
      verified: verified ?? this.verified,
      secondsLeft: secondsLeft ?? this.secondsLeft,
    );
  }
}

class OtpVerificationNotifier extends StateNotifier<OtpVerificationState> {
  OtpVerificationNotifier(this._forgot) : super(OtpVerificationState());

  final ForgotPasswordNotifier _forgot;
  static const _otpLen = 6;

  void updateDigit(String code) {
    state = state.copyWith(code: code, errorMessage: null);
  }

  Future<bool> verify() async {
    if (state.code.length != _otpLen) {
      state = state.copyWith(errorMessage: 'Enter 6-digit code');
      return false;
    }
    state = state.copyWith(isLoading: true, errorMessage: null);
    await Future.delayed(const Duration(milliseconds: 600));
    final ok = state.code == _forgot.state.expectedOtp;
    state = state.copyWith(isLoading: false, verified: ok);
    if (!ok) {
      state = state.copyWith(errorMessage: 'Invalid code');
    }
    return ok;
  }

  Future<void> resend() async {
    // Optional countdown example
    state = state.copyWith(secondsLeft: 15);
    for (int i = 14; i >= 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWith(secondsLeft: i);
    }
    // For demo, just keep the same code on resend.
  }
}

final otpVerificationProvider =
StateNotifierProvider<OtpVerificationNotifier, OtpVerificationState>((ref) {
  final forgot = ref.read(forgotPasswordProvider.notifier);
  return OtpVerificationNotifier(forgot);
});
