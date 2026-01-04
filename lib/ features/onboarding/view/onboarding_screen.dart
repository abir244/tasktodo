
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/onboarding_viewmodel.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(onboardingViewModelProvider);
    final viewModel = ref.read(onboardingViewModelProvider.notifier);

    /// 🟡 ONBOARDING DATA
    final onboardingItems = [
      {
        'image': 'assets/images/onboard1.png',
        'title': 'Welcome to Our Faith Connects',
        'description':
        'Discover the best events near you and meet new people in your community.',
        'buttonText': 'Next',
      },
      {
        'image': 'assets/images/onboard2.png',
        'title': 'Experience the Ultimate Event',
        'description':
        'Join exciting events and connect with people who share your faith.',
        'buttonText': 'Next',
      },
      {
        'image': 'assets/images/onboard3.png',
        'title': 'Enjoy Your Favorite Event',
        'description':
        'Meet new people and strengthen your connections through events.',
        'buttonText': 'Get Started',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black, // avoids any gaps on extreme aspect ratios
      body: Stack(
        children: [
          /// 🔹 FULL BACKGROUND IMAGE (sharp: decode at display pixel size)
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final dpr = MediaQuery.of(context).devicePixelRatio;
                // Target decode size in physical pixels
                final targetWidthPx = (constraints.maxWidth * dpr).round();
                final targetHeightPx = (constraints.maxHeight * dpr).round();

                return Image.asset(
                  onboardingItems[currentIndex]['image']!,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  // Ask the engine to decode close to display size for crispness
                  cacheWidth: targetWidthPx,
                  cacheHeight: targetHeightPx,
                  // Try `FilterQuality.none` if you prefer less smoothing
                  filterQuality: FilterQuality.high,
                );
              },
            ),
          ),

          /// 🔹 Optional: gradient overlay for better text readability
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black54,
                    Colors.black87,
                  ],
                  stops: [0.4, 0.75, 1.0],
                ),
              ),
            ),
          ),

          /// 🔹 TEXT AREA (BOTTOM HALF)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.45,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// TEXT CONTENT
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          onboardingItems.length,
                              (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: currentIndex == index ? 14 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: currentIndex == index
                                  ? Colors.amber
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        onboardingItems[currentIndex]['title']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // ✅ PURE WHITE HEADING
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        onboardingItems[currentIndex]['description']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                              .withOpacity(0.8), // ✅ Softer white for description
                        ),
                      ),
                    ],
                  ),

                  /// BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (currentIndex < onboardingItems.length - 1) {
                          viewModel.next(onboardingItems.length);
                        } else {
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      },
                      child: Text(
                        onboardingItems[currentIndex]['buttonText']!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
