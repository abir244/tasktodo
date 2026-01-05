import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/splash_viewmodel.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(splashViewModelProvider);

    /// ⚠️ start() should be called once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.start(() {
        Navigator.pushReplacementNamed(context, '/onboarding');
      });
    });

    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/splash.png',
          fit: BoxFit.cover, // ✅ fills whole screen
        ),
      ),
    );
  }
}
