
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/document_verification_state.dart';
import '../viewmodel/document_verification_notifier.dart';
import 'scan_id_card_screen.dart';

class SelectDocumentTypeScreen extends ConsumerWidget {
  const SelectDocumentTypeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(documentVerificationProvider);
    final notifier = ref.read(documentVerificationProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select Document Type',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text('Need to verify with document to get started',
                  style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 20),

              _docTile(
                label: 'National ID Card',
                icon: Icons.badge_outlined,
                selected: state.selectedType == DocumentType.nid,
                onTap: () => notifier.selectType(DocumentType.nid),
              ),
              const SizedBox(height: 12),
              _docTile(
                label: 'Passport',
                icon: Icons.travel_explore_outlined,
                selected: state.selectedType == DocumentType.passport,
                onTap: () => notifier.selectType(DocumentType.passport),
              ),
              const SizedBox(height: 12),
              _docTile(
                label: 'Driver License',
                icon: Icons.credit_card,
                selected: state.selectedType == DocumentType.license,
                onTap: () => notifier.selectType(DocumentType.license),
              ),

              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: state.selectedType == null
                        ? const Color(0xFF616161)
                        : const Color(0xFFFFC107),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: state.selectedType == null
                      ? null
                      : () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ScanIdCardScreen()),
                  ),
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _docTile({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF131318),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? const Color(0xFFFFC107) : const Color(0xFF3A3A3A),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            Icon(Icons.chevron_right,
                color: selected ? const Color(0xFFFFC107) : Colors.white54),
          ],
        ),
      ),
    );
  }
}
