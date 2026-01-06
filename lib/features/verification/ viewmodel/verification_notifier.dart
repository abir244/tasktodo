
// lib/features/verification/viewmodel/verification_notifier.dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/verification_api.dart';
import '../data/verification_providers.dart';

/// Async status for the verification flow.
enum VerificationStatus {
  idle,
  sendingCode,   // sending the OTP
  verifyingCode, // verifying the OTP
}

/// Immutable state for the verification flow.
class VerificationState {
  // -------- Page 2 (Profile) --------
  final String name;
  final String email;
  final String phone;
  /// Display string (formatted), e.g., "2nd September, 1985"
  final String dob;
  /// "Male" | "Female" | "Other" (or empty)
  final String gender;
  final String address;

  // Validation
  final bool isEmailValid;

  // Async status & error
  final VerificationStatus status;
  final String? errorMessage;

  // -------- Page 3 (OTP) --------
  final String code;            // 0..5 digits
  final bool isButtonEnabled;   // true if code length == 5 and not verifying
  final int resendSeconds;      // cooldown for resend

  // Internal (for simple throttle on resend)
  final DateTime? _lastResendAt;

  const VerificationState({
    // Profile defaults
    this.name = '',
    this.email = '',
    this.phone = '',
    this.dob = '',
    this.gender = '',
    this.address = '',

    // Validation
    this.isEmailValid = false,

    // Async
    this.status = VerificationStatus.idle,
    this.errorMessage,

    // OTP
    this.code = '',
    this.isButtonEnabled = false,
    this.resendSeconds = 0,

    // internal
    DateTime? lastResendAt,
  }) : _lastResendAt = lastResendAt;

  bool get isSending => status == VerificationStatus.sendingCode;
  bool get isVerifying => status == VerificationStatus.verifyingCode;

  /// Determines whether the "Continue" button on the profile page should be enabled.
  bool get isProfileComplete =>
      name.trim().isNotEmpty &&
          email.trim().isNotEmpty &&
          isEmailValid &&
          phone.trim().length >= 7 &&
          dob.trim().isNotEmpty &&
          gender.trim().isNotEmpty &&
          address.trim().isNotEmpty;

  VerificationState copyWith({
    String? name,
    String? email,
    String? phone,
    String? dob,
    String? gender,
    String? address,
    bool? isEmailValid,
    VerificationStatus? status,
    String? errorMessage, // pass explicit null to clear
    String? code,
    bool? isButtonEnabled,
    int? resendSeconds,
    DateTime? lastResendAt,
  }) {
    return VerificationState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      status: status ?? this.status,
      errorMessage: errorMessage,
      code: code ?? this.code,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
      resendSeconds: resendSeconds ?? this.resendSeconds,
      lastResendAt: lastResendAt ?? _lastResendAt,
    );
  }
}

/// Riverpod StateNotifier for the verification flow.
class VerificationNotifier extends StateNotifier<VerificationState> {
  final VerificationApi _api;
  Timer? _timer;

  VerificationNotifier(this._api) : super(const VerificationState());

  // -------- Profile setters --------
  void updateName(String v) =>
      state = state.copyWith(name: v, errorMessage: null);

  void updateEmail(String v) {
    final email = v.trim();
    final valid = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);
    state = state.copyWith(email: email, isEmailValid: valid, errorMessage: null);
  }

  void updatePhone(String v) =>
      state = state.copyWith(phone: v, errorMessage: null);

  void updateDob(String v) =>
      state = state.copyWith(dob: v, errorMessage: null);

  void updateGender(String v) =>
      state = state.copyWith(gender: v, errorMessage: null);

  void updateAddress(String v) =>
      state = state.copyWith(address: v, errorMessage: null);

  // -------- Send OTP --------
  Future<bool> sendCode() async {
    if (state.isSending) return false;

    if (!state.isProfileComplete) {
      state = state.copyWith(errorMessage: 'Please complete all required fields.');
      return false;
    }

    state = state.copyWith(
      status: VerificationStatus.sendingCode,
      errorMessage: null,
    );

    try {
      await _api.sendOtp(state.email);
      _startCooldown(30); // e.g., 30s for resend
      state = state.copyWith(
        status: VerificationStatus.idle,
        lastResendAt: DateTime.now(),
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        status: VerificationStatus.idle,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  // -------- OTP input --------
  void updateCode(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    final capped = digits.length > 5 ? digits.substring(0, 5) : digits;

    state = state.copyWith(
      code: capped,
      isButtonEnabled: capped.length == 5 && !state.isVerifying,
      errorMessage: null,
    );
  }

  void clearCode() =>
      state = state.copyWith(code: '', isButtonEnabled: false);

  // -------- Verify OTP --------
  Future<bool> verify() async {
    if (!state.isButtonEnabled || state.isVerifying) return false;

    state = state.copyWith(
      status: VerificationStatus.verifyingCode,
      errorMessage: null,
    );

    try {
      await _api.verifyOtp(state.email, state.code);
      state = state.copyWith(status: VerificationStatus.idle);
      return true;
    } catch (e) {
      state = state.copyWith(
        status: VerificationStatus.idle,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  // -------- Resend with cooldown & simple throttle --------
  void resendCode() {
    if (state.resendSeconds > 0 || state.isSending) return;

    // Throttle: if last resend was < 5s ago, ignore
    final last = _getLastResendAt();
    if (last != null && DateTime.now().difference(last) < const Duration(seconds: 5)) {
      return;
    }

    sendCode(); // reuse same logic & cooldown
  }

  DateTime? _getLastResendAt() => state._lastResendAt;

  void _startCooldown(int seconds) {
    _timer?.cancel();
    state = state.copyWith(resendSeconds: seconds);

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      final next = state.resendSeconds - 1;
      if (next <= 0) {
        _timer?.cancel();
        state = state.copyWith(resendSeconds: 0);
      } else {
        state = state.copyWith(resendSeconds: next);
      }
    });
  }

  /// Resets the whole flow.
  void resetAll() {
    _timer?.cancel();
    state = const VerificationState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// Public provider used by your screens.
/// It injects the API instance from verification_providers.dart.
final verificationProvider =
StateNotifierProvider<VerificationNotifier, VerificationState>((ref) {
  final api = ref.watch(verificationApiProvider);
  return VerificationNotifier(api);
});

