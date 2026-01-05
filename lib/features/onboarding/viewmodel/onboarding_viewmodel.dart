import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for onboarding ViewModel
final onboardingViewModelProvider =
StateNotifierProvider<OnboardingViewModel, int>(
      (ref) => OnboardingViewModel(),
);

/// ViewModel (Business Logic only)
class OnboardingViewModel extends StateNotifier<int> {
  OnboardingViewModel() : super(0);

  /// Move to next onboarding item
  void next(int totalLength) {
    if (state < totalLength - 1) {
      state++;
    }
  }

  /// Reset or skip onboarding
  void reset() {
    state = 0;
  }
}
