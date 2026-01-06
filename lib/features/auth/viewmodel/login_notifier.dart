
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_providers.dart';
import '../data/auth_repository.dar.dart';


class LoginState {
  final String email;
  final String password;
  final bool isEmailValid;
  final bool obscurePassword;
  final bool isLoading;
  final String? errorMessage;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isEmailValid = false,
    this.obscurePassword = true,
    this.isLoading = false,
    this.errorMessage,
  });

  bool get canSubmit =>
      email.trim().isNotEmpty &&
          isEmailValid &&
          password.trim().isNotEmpty &&
          !isLoading;

  LoginState copyWith({
    String? email,
    String? password,
    bool? isEmailValid,
    bool? obscurePassword,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class LoginNotifier extends StateNotifier<LoginState> {
  final AuthRepository _repo;

  LoginNotifier(this._repo) : super(const LoginState());

  void updateEmail(String v) {
    final email = v.trim();
    final valid = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);
    state = state.copyWith(email: email, isEmailValid: valid, errorMessage: null);
  }

  void updatePassword(String v) {
    state = state.copyWith(password: v, errorMessage: null);
  }

  void toggleObscure() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  Future<bool> submit() async {
    if (!state.canSubmit) return false;
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _repo.signIn(email: state.email, password: state.password);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return LoginNotifier(repo);
});

