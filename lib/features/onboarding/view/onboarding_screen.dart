
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/onboarding_viewmodel.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(onboardingViewModelProvider);
    final viewModel = ref.read(onboardingViewModelProvider.notifier);

    /// 🟡 ONBOARDING DATA (unchanged)
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

    final item = onboardingItems[currentIndex];
    final size = MediaQuery.of(context).size;
    final dpr = MediaQuery.of(context).devicePixelRatio;

    // Bottom container limits:
    // – min height hugs small content
    // – max height ≈ half screen
    final minH = size.height * 0.35;
    final maxH = size.height * 0.50;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// 🔹 FULL-BLEED BACKGROUND IMAGE
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final targetWidthPx = (constraints.maxWidth * dpr).round();
                final targetHeightPx = (constraints.maxHeight * dpr).round();
                return Image.asset(
                  item['image']!,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  cacheWidth: targetWidthPx,
                  cacheHeight: targetHeightPx,
                  filterQuality: FilterQuality.high,
                );
              },
            ),
          ),

          ///  READABILITY OVERLAY
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

          /// 🔹 BOTTOM CONTAINER — anchored to bottom, height based on text
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Internal paddings
                  const padH = 20.0;
                  const padVTop = 22.0;
                  const padVBottom = 20.0;

                  // Styles (match design)
                  const titleStyle = TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  );
                  final descStyle = TextStyle(
                    fontSize: 16,
                    height: 1.4,
                    color: Colors.white.withOpacity(0.80),
                  );

                  // Decorative small centered dotted line parameters
                  const dottedWidth = 48.0;   // total width of the dotted divider
                  const dottedHeight = 6.0;   // vertical space it occupies
                  const dottedGap = 12.0;     // gap below dotted line

                  // Dots indicator parameters
                  const dotsH = 8.0;          // dot height
                  const dotsGap = 18.0;       // gap after dots

                  // Spacing around title/desc/button
                  const titleGap = 10.0;
                  const descGap = 20.0;
                  const buttonH = 50.0;

                  // Measure text heights to decide desired container height
                  final contentWidth = constraints.maxWidth - (padH * 2);

                  double measureTextHeight(
                      String text,
                      TextStyle style,
                      double maxWidth,
                      ) {
                    final tp = TextPainter(
                      text: TextSpan(text: text, style: style),
                      textDirection: TextDirection.ltr,
                      maxLines: null,
                    )..layout(minWidth: 0, maxWidth: maxWidth);
                    return tp.size.height;
                  }

                  final titleH =
                  measureTextHeight(item['title']!, titleStyle, contentWidth);
                  final descH =
                  measureTextHeight(item['description']!, descStyle, contentWidth);

                  // Compute desired height
                  final desired =
                      padVTop +
                          dotsH +
                          dotsGap +
                          dottedHeight +
                          dottedGap +
                          titleH +
                          titleGap +
                          descH +
                          descGap +
                          buttonH +
                          padVBottom;

                  // Clamp within min .. max
                  final targetH = desired.clamp(minH, maxH);
                  final shouldScroll = targetH >= maxH - 0.5;

                  return AnimatedSize(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: targetH.toDouble(),
                      width: constraints.maxWidth,
                      padding: const EdgeInsets.fromLTRB(padH, padVTop, padH, padVBottom),
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: const Color(0xFF131318),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(28),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 12,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),

                      // Layout: dots + dotted divider + (scrollable text) + fixed button
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _DotsIndicator(
                            total: onboardingItems.length,
                            current: currentIndex,
                          ),
                          const SizedBox(height: dotsGap),

                          // Centered dotted-like line (decorative divider)
                          SizedBox(
                            width: dottedWidth,
                            height: dottedHeight,
                            child: const _DottedDivider(
                              dotSize: 4,
                              dotSpacing: 4,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: dottedGap),

                          // Title + description either scroll or not
                          Expanded(
                            child: shouldScroll
                                ? SingleChildScrollView(
                              physics: const ClampingScrollPhysics(),
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item['title']!,
                                    textAlign: TextAlign.center,
                                    style: titleStyle,
                                  ),
                                  const SizedBox(height: titleGap),
                                  Text(
                                    item['description']!,
                                    textAlign: TextAlign.center,
                                    style: descStyle,
                                  ),
                                ],
                              ),
                            )
                                : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item['title']!,
                                  textAlign: TextAlign.center,
                                  style: titleStyle,
                                ),
                                const SizedBox(height: titleGap),
                                Text(
                                  item['description']!,
                                  textAlign: TextAlign.center,
                                  style: descStyle,
                                ),
                                const SizedBox(height: descGap),
                              ],
                            ),
                          ),

                          // Fixed Bottom Button (always aligned to container bottom)
                          SizedBox(
                            width: double.infinity,
                            height: buttonH,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Color(0xFFEDDF99),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () {
                                if (currentIndex < onboardingItems.length - 1) {
                                  viewModel.next(onboardingItems.length);
                                } else {
                                  Navigator.pushReplacementNamed(context, '/register');
                                }
                              },
                              child: Text(
                                item['buttonText']!,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
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

/// Dots indicator (animated width for active)
class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({
    required this.total,
    required this.current,
  });

  final int total;
  final int current;

  @override
  Widget build(BuildContext context) {
    const dotActiveColor = Colors.amber;
    const dotInactiveColor = Color(0xFF6D6D6D);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        total,
            (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: current == i ? 14 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: current == i ? dotActiveColor : dotInactiveColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

/// A compact dotted-like divider made of small circles.
/// Width is controlled by the parent; dots get centered automatically.
class _DottedDivider extends StatelessWidget {
  const _DottedDivider({
    required this.dotSize,
    required this.dotSpacing,
    this.color = Colors.white70,
  });

  final double dotSize;
  final double dotSpacing;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        // compute how many dots fit in available width
        final count = (c.maxWidth / (dotSize + dotSpacing)).floor().clamp(3, 20);
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            count,
                (i) => Container(
              width: dotSize,
              height: dotSize,
              margin: EdgeInsets.only(right: i == count - 1 ? 0 : dotSpacing),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}
