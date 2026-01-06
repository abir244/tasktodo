
import 'dart:async';

/// Replace this with Firebase Auth or your backend later.
abstract class AuthRepository {
  Future<void> signIn({required String email, required String password});
}

class FakeAuthRepository implements AuthRepository {
  @override
  Future<void> signIn({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Simple demo rule: accept any password length >= 6, else throw.
    if (password.length < 6) {
      throw Exception('Invalid email or password.');
    }
  }
}
