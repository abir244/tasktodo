
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResetPasswordState {
  final String newPassword;
  final String confirmPassword;
  final bool obscureNew;
  final bool obscureConfirm;
  final bool isLoading;
  final String? errorMessage;
  final bool success;

  ResetPasswordState({
    this.newPassword = '',
    this.confirmPassword = '',
    this.obscureNew = true,
    this.obscureConfirm = true,
    this.isLoading = false,
    this.errorMessage,
    this.success = false,
  });

  bool get canSubmit =>
      newPassword.isNotEmpty &&
          confirmPassword.isNotEmpty &&
          newPassword == confirmPassword &&
          newPassword.length >= 6;

  ResetPasswordState copyWith({
    String? newPassword,
    String? confirmPassword,
    bool? obscureNew,
    bool? obscureConfirm,
    bool? isLoading,
    String? errorMessage,
    bool? success,
  }) {
    return ResetPasswordState(
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      obscureNew: obscureNew ?? this.obscureNew,
      obscureConfirm: obscureConfirm ?? this.obscureConfirm,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      success: success ?? this.success,
    );
  }
}

class ResetPasswordNotifier extends StateNotifier<ResetPasswordState> {
  ResetPasswordNotifier() : super(ResetPasswordState());

  void updateNew(String v) => state = state.copyWith(newPassword: v, errorMessage: null);
  void updateConfirm(String v) => state = state.copyWith(confirmPassword: v, errorMessage: null);
  void toggleObscureNew() => state = state.copyWith(obscureNew: !state.obscureNew);
  void toggleObscureConfirm() => state = state.copyWith(obscureConfirm: !state.obscureConfirm);

  Future<bool> submit() async {
    if (!state.canSubmit) {
      state = state.copyWith(errorMessage: 'Passwords must match and be ≥ 6 chars');
      return false;
    }
    state = state.copyWith(isLoading: true, errorMessage: null);
    await Future.delayed(const Duration(milliseconds: 800)); // simulate API call
    state = state.copyWith(isLoading: false, success: true);
    return true;
  }

  void reset() => state = ResetPasswordState();
}

final resetPasswordProvider =
StateNotifierProvider<ResetPasswordNotifier, ResetPasswordState>(
        (ref) => ResetPasswordNotifier());
