
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DestinationType { email, phone }

class ForgotPasswordState {
  final bool isLoading;
  final String? errorMessage;
  final bool sent;
  final DestinationType? destinationType;
  final String destinationValue; // email or phone (with country code for phone)
  final String expectedOtp;      // for demo: 6-digit preset

  ForgotPasswordState({
    this.isLoading = false,
    this.errorMessage,
    this.sent = false,
    this.destinationType,
    this.destinationValue = '',
    this.expectedOtp = '',
  });

  ForgotPasswordState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? sent,
    DestinationType? destinationType,
    String? destinationValue,
    String? expectedOtp,
  }) {
    return ForgotPasswordState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      sent: sent ?? this.sent,
      destinationType: destinationType ?? this.destinationType,
      destinationValue: destinationValue ?? this.destinationValue,
      expectedOtp: expectedOtp ?? this.expectedOtp,
    );
  }
}

class ForgotPasswordNotifier extends StateNotifier<ForgotPasswordState> {
  ForgotPasswordNotifier() : super(ForgotPasswordState());

  // Demo preset OTP: 123456
  static const _demoOtp = '123456';

  void reset() {
    state = ForgotPasswordState();
  }

  Future<bool> sendEmailCode(String email) async {
    if (email.trim().isEmpty || !email.contains('@')) {
      state = state.copyWith(errorMessage: 'Please enter a valid email');
      return false;
    }
    state = state.copyWith(isLoading: true, errorMessage: null);
    await Future.delayed(const Duration(milliseconds: 600)); // simulate
    state = state.copyWith(
      isLoading: false,
      sent: true,
      destinationType: DestinationType.email,
      destinationValue: email.trim(),
      expectedOtp: _demoOtp,
    );
    return true;
  }

  Future<bool> sendPhoneCode(String fullPhone) async {
    if (fullPhone.trim().isEmpty || fullPhone.length < 6) {
      state = state.copyWith(errorMessage: 'Please enter a valid phone number');
      return false;
    }
    state = state.copyWith(isLoading: true, errorMessage: null);
    await Future.delayed(const Duration(milliseconds: 600)); // simulate
    state = state.copyWith(
      isLoading: false,
      sent: true,
      destinationType: DestinationType.phone,
      destinationValue: fullPhone.trim(),
      expectedOtp: _demoOtp,
    );
    return true;
  }
}

final forgotPasswordProvider =
StateNotifierProvider<ForgotPasswordNotifier, ForgotPasswordState>(
        (ref) => ForgotPasswordNotifier());
