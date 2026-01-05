
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/document_verification_notifier.dart';

class ConfirmIdentityScreen extends ConsumerWidget {
  const ConfirmIdentityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(documentVerificationProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Confirm Identity',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),

              _infoRow('Full Name', state.parsed.fullName),
              _infoRow('Date of Birth', state.parsed.dob),
              _infoRow('ID Number', state.parsed.idNumber),
              _infoRow('Gender', state.parsed.gender),
              _infoRow('Issue Date', state.parsed.issueDate),
              _infoRow('Address', state.parsed.address),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC107),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    // TODO: submit to backend then proceed to app home
                    Navigator.pop(context); // back to previous
                  },
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF131318),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.white70)),
          ),
          const SizedBox(width: 12),
          Text(value.isEmpty ? '-' : value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
