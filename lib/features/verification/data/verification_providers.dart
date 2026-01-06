
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'verification_api.dart';

// Build Dio client (update baseUrl)
final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    baseUrl: 'https://your-api-url.com', // ⬅ CHANGE THIS
    headers: {'Content-Type': 'application/json'},
  ));
});

// Provide VerificationApi
final verificationApiProvider = Provider<VerificationApi>((ref) {
  final dio = ref.watch(dioProvider);
  return VerificationApi(dio);
});
