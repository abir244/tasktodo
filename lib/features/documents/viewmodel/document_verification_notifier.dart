
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/document_verification_state.dart';

final documentVerificationProvider =
StateNotifierProvider<DocumentVerificationNotifier, DocumentVerificationState>(
      (ref) => DocumentVerificationNotifier(),
);

class DocumentVerificationNotifier extends StateNotifier<DocumentVerificationState> {
  DocumentVerificationNotifier() : super(const DocumentVerificationState());

  void selectType(DocumentType type) {
    state = state.copyWith(selectedType: type);
  }

  /// Accept camera file path and simulate analysis
  Future<void> captureFrontFromPath(String path) async {
    state = state.copyWith(status: ScanStatus.analyzing, capturedImagePath: path);

    // TODO: Replace with real ML/OCR checks (quality, age, OCR)
    await Future.delayed(const Duration(seconds: 1));

    // Example decision: default success. Call markInvalidPhoto() / markAgeFail() based on real rules.
    state = state.copyWith(status: ScanStatus.success);

    // Populate parsed data for confirmation
    state = state.copyWith(
      parsed: state.parsed.copyWith(
        fullName: 'Abir Molla',
        dob: '2nd September, 1999',
        idNumber: '1234567890',
        gender: 'Male',
        issueDate: '1st January, 2024',
        address: 'Gulshan, Dhaka',
      ),
    );
  }

  void markInvalidPhoto() {
    state = state.copyWith(status: ScanStatus.invalidPhoto);
  }

  void markAgeFail() {
    state = state.copyWith(status: ScanStatus.ageFail);
  }

  void retake() {
    state = state.copyWith(
      status: ScanStatus.idle,
      capturedImagePath: '',
      parsed: const ParsedIdData(),
    );
  }
}
