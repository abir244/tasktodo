// lib/viewmodel/verification_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'verification_state.freezed.dart';

@freezed
class VerificationState with _$VerificationState {
  const VerificationState._(); // ✅ REQUIRED for extensions

  const factory VerificationState({
    @Default('') String name,
    @Default('') String email,
    @Default('') String phone,
    @Default('') String dob,
    @Default('') String gender,
    @Default('') String address,

    @Default(false) bool isSending,
    @Default('') String errorMessage,
  }) = _VerificationState;
}

extension VerificationStateX on VerificationState {
  bool get isEmailValid =>
      RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);

  bool get isProfileComplete =>
      name.isNotEmpty &&
          email.isNotEmpty &&
          isEmailValid &&
          phone.isNotEmpty &&
          dob.isNotEmpty &&
          gender.isNotEmpty &&
          address.isNotEmpty;
}
