
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ✅ Correct import (no .txt)
import '../../verification/view/complete_profile_screen.dart';
import '../viewmodel/document_verification_notifier.dart';
import '../../../main.dart'; // to access MyApp.routeVerifyProfile if using named routes

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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Text(
                  'Confirm Identity',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'ID information',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),

              _infoRow('Full Name', state.parsed.fullName),
              _infoRow('Email Address', 'alexa.mate@example.com'),
              _infoRow('Mobile Number', '(800) 555-0111'),
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
                    backgroundColor: const Color(0xFFEDDF99),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    // ✅ Option A: named route (recommended with your main.dart)
                    Navigator.pushNamed(context, MyApp.routeVerifyProfile);

                    // ✅ Option B: direct push (uncomment if you prefer)
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (_) => const CompleteProfileScreen()),
                    // );
                  },
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
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
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              (value.isEmpty ? '-' : value),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
