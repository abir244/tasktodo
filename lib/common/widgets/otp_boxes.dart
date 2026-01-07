
import 'package:flutter/material.dart';

class OtpBoxes extends StatefulWidget {
  final int length;
  final void Function(String code) onChanged;
  final String? initial;

  const OtpBoxes({
    super.key,
    this.length = 6,
    required this.onChanged,
    this.initial,
  });

  @override
  State<OtpBoxes> createState() => _OtpBoxesState();
}

class _OtpBoxesState extends State<OtpBoxes> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _nodes;

  @override
  void initState() {
    super.initState();
    _controllers =
        List.generate(widget.length, (i) => TextEditingController());
    _nodes = List.generate(widget.length, (i) => FocusNode());

    if (widget.initial != null && widget.initial!.length == widget.length) {
      for (int i = 0; i < widget.length; i++) {
        _controllers[i].text = widget.initial![i];
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onChanged(widget.initial!);
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_nodes.isNotEmpty) _nodes.first.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _emit() {
    final code = _controllers.map((c) => c.text).join();
    widget.onChanged(code);
  }

  @override
  Widget build(BuildContext context) {
    final boxDecoration = BoxDecoration(
      color: const Color(0xFF131318),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFF3A3A3A)),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (i) {
        return Container(
          width: 48,
          height: 56,
          decoration: boxDecoration,
          alignment: Alignment.center,
          child: TextField(
            controller: _controllers[i],
            focusNode: _nodes[i],
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
            ),
            onChanged: (v) {
              if (v.isNotEmpty) {
                // move to next
                if (i + 1 < widget.length) {
                  _nodes[i + 1].requestFocus();
                } else {
                  _nodes[i].unfocus();
                }
              }
              _emit();
            },
            onSubmitted: (_) => _emit(),
            onEditingComplete: _emit,
          ),
        );
      }),
    );
  }
}
