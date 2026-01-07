
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/onboarding_viewmodel.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(onboardingViewModelProvider);
    final viewModel = ref.read(onboardingViewModelProvider.notifier);

    final onboardingItems = [
      {
        'image': 'assets/images/onboard1.png',
        'title': 'Welcome to Our Faith Connects',
        'description': 'Discover the best events near you and meet new people in your community.',
        'buttonText': 'Next',
      },
      {
        'image': 'assets/images/onboard2.png',
        'title': 'Experience the Ultimate Event',
        'description': 'Join exciting events and connect with people who share your faith.',
        'buttonText': 'Next',
      },
      {
        'image': 'assets/images/onboard3.png',
        'title': 'Enjoy Your Favorite Event',
        'description': 'Meet new people and strengthen your connections through events.',
        'buttonText': 'Get Started',
      },
    ];

    final item = onboardingItems[currentIndex];
    final size = MediaQuery.of(context).size;

    final minH = size.height * 0.35;
    final maxH = size.height * 0.50;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// Background
          Positioned.fill(
            child: Image.asset(
              item['image']!,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
          ),

          /// Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                  stops: [0.5, 1.0],
                ),
              ),
            ),
          ),

          /// Bottom Container
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const padH = 20.0;
                  const verticalPadding = EdgeInsets.fromLTRB(20, 22, 20, 20);

                  const titleStyle = TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  );
                  final descStyle = TextStyle(
                    fontSize: 16,
                    height: 1.4,
                    color: Colors.white.withOpacity(0.8),
                  );

                  final contentWidth = constraints.maxWidth - (padH * 2);

                  double textHeight(String txt, TextStyle style) {
                    final tp = TextPainter(
                      text: TextSpan(text: txt, style: style),
                      textDirection: TextDirection.ltr,
                      maxLines: null,
                    )..layout(maxWidth: contentWidth);
                    return tp.size.height;
                  }

                  final desiredHeight = textHeight(item['title']!, titleStyle) +
                      textHeight(item['description']!, descStyle) +
                      160; // extra padding + button + spacing

                  final targetHeight =
                  desiredHeight.clamp(minH, maxH).toDouble();

                  final shouldScroll = targetHeight >= maxH;

                  return AnimatedSize(
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOut,
                    child: Container(
                      height: targetHeight,
                      decoration: BoxDecoration(
                        color: const Color(0xFF131318),
                        borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(28)),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            offset: const Offset(0, -3),
                            color: Colors.black.withOpacity(0.25),
                          ),
                        ],
                      ),
                      padding: verticalPadding,
                      child: Column(
                        children: [
                          /// Single (combined) dotted indicator
                          _DottedDivider(
                            dotSize: 6,
                            dotSpacing: 6,
                            color: Colors.white70,
                            activeIndex: currentIndex,
                            total: onboardingItems.length,
                          ),

                          const SizedBox(height: 22),

                          /// Scrollable text if needed
                          Expanded(
                            child: shouldScroll
                                ? SingleChildScrollView(
                              child: _OnboardTexts(
                                title: item['title']!,
                                description: item['description']!,
                                titleStyle: titleStyle,
                                descStyle: descStyle,
                              ),
                            )
                                : _OnboardTexts(
                              title: item['title']!,
                              description: item['description']!,
                              titleStyle: titleStyle,
                              descStyle: descStyle,
                            ),
                          ),

                          /// Button
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFEDDF99),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                if (currentIndex < onboardingItems.length - 1) {
                                  viewModel.next(onboardingItems.length);
                                } else {
                                  Navigator.pushReplacementNamed(context, '/register');
                                }
                              },
                              child: Text(item['buttonText']!, style: const TextStyle(fontSize: 16)),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Simplified reusable Text block
class _OnboardTexts extends StatelessWidget {
  final String title;
  final String description;
  final TextStyle titleStyle;
  final TextStyle descStyle;

  const _OnboardTexts({
    required this.title,
    required this.description,
    required this.titleStyle,
    required this.descStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, textAlign: TextAlign.center, style: titleStyle),
        const SizedBox(height: 12),
        Text(description, textAlign: TextAlign.center, style: descStyle),
      ],
    );
  }
}

/// Single dotted indicator that also highlights current page
class _DottedDivider extends StatelessWidget {
  final double dotSize;
  final double dotSpacing;
  final Color color;
  final int total;
  final int activeIndex;

  const _DottedDivider({
    required this.dotSize,
    required this.dotSpacing,
    required this.total,
    required this.activeIndex,
    this.color = Colors.white70,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final isActive = i == activeIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isActive ? dotSize * 2.2 : dotSize,
          height: dotSize,
          margin: EdgeInsets.only(right: i == total - 1 ? 0 : dotSpacing),
          decoration: BoxDecoration(
            color: isActive ? Colors.amber : color,
            borderRadius: BorderRadius.circular(6),
          ),
        );
      }),
    );
  }
}

