
// lib/viewmodel/register_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/register_state.dart';

final registerProvider =
StateNotifierProvider<RegisterNotifier, AsyncValue<RegisterState>>(
      (ref) => RegisterNotifier(),
);

class RegisterNotifier extends StateNotifier<AsyncValue<RegisterState>> {
  RegisterNotifier() : super(const AsyncValue.data(RegisterState()));

  void _set(RegisterState newState) => state = AsyncValue.data(newState);

  void updateName(String v) => _set(state.value!.copyWith(name: v.trim()));
  void updateEmail(String v) => _set(state.value!.copyWith(email: v.trim()));
  void updatePhone(String v) => _set(state.value!.copyWith(phone: v.trim()));
  void updateGender(String v) => _set(state.value!.copyWith(gender: v));

  void updateDob(DateTime v) => _set(state.value!.copyWith(dob: v));
  void updateCountry(String v) => _set(state.value!.copyWith(country: v, state: '', city: ''));
  void updateState(String v) => _set(state.value!.copyWith(state: v, city: ''));
  void updateCity(String v) => _set(state.value!.copyWith(city: v));

  Future<void> submit() async {
    final s = state.value!;
    if (!s.isValid) return;

    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 800));
    // TODO: replace with real API call / navigation
    state = AsyncValue.data(s);
  }
}

