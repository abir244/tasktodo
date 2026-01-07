
import 'package:flutter/material.dart';

const kYellow = Color(0xFFEDDF99);

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool loading;
  final double height;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.loading = false,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed != null ? kYellow : Colors.grey.shade800,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        onPressed: loading ? null : onPressed,
        child: loading
            ? const SizedBox(
            height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2))
            : Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

