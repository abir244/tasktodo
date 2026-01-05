import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final splashViewModelProvider = Provider<SplashViewModel>((ref) {
  return SplashViewModel(ref);
});

class SplashViewModel {
  final Ref ref;

  SplashViewModel(this.ref);

  void start(Function onFinish) {
    Timer(const Duration(seconds: 3), () {
      onFinish();
    });
  }
}
