
import 'package:flutter/material.dart';

class DarkGradientScaffold extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const DarkGradientScaffold({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(20, 24, 20, 24),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0D0D12), Color(0xFF131318)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
