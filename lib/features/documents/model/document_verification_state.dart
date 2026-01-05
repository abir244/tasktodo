
import 'package:flutter/foundation.dart';

/// Supported document types
enum DocumentType { nid, passport, license }

/// Scan status lifecycle
enum ScanStatus {
  idle,           // before capture
  analyzing,      // after capture while checking
  invalidPhoto,   // failed quality checks
  ageFail,        // age < minimum requirement
  success,        // good to confirm
}

/// Parsed ID data to present in confirmation screen
@immutable
class ParsedIdData {
  final String fullName;
  final String dob;        // e.g. "2nd September, 1999"
  final String idNumber;
  final String gender;
  final String issueDate;
  final String address;

  const ParsedIdData({
    this.fullName = '',
    this.dob = '',
    this.idNumber = '',
    this.gender = '',
    this.issueDate = '',
    this.address = '',
  });

  ParsedIdData copyWith({
    String? fullName,
    String? dob,
    String? idNumber,
    String? gender,
    String? issueDate,
    String? address,
  }) {
    return ParsedIdData(
      fullName: fullName ?? this.fullName,
      dob: dob ?? this.dob,
      idNumber: idNumber ?? this.idNumber,
      gender: gender ?? this.gender,
      issueDate: issueDate ?? this.issueDate,
      address: address ?? this.address,
    );
  }
}

/// Root state for document verification flow
@immutable
class DocumentVerificationState {
  final DocumentType? selectedType;
  final ScanStatus status;
  final String capturedImagePath; // physical file path from camera
  final ParsedIdData parsed;

  const DocumentVerificationState({
    this.selectedType,
    this.status = ScanStatus.idle,
    this.capturedImagePath = '',
    this.parsed = const ParsedIdData(),
  });

  DocumentVerificationState copyWith({
    DocumentType? selectedType,
    ScanStatus? status,
    String? capturedImagePath,
    ParsedIdData? parsed,
  }) {
    return DocumentVerificationState(
      selectedType: selectedType ?? this.selectedType,
      status: status ?? this.status,
      capturedImagePath: capturedImagePath ?? this.capturedImagePath,
      parsed: parsed ?? this.parsed,
    );
  }
}
