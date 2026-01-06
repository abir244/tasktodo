
import 'package:dio/dio.dart';

class VerificationApi {
  final Dio _dio;

  VerificationApi(this._dio);

  Future<void> sendOtp(String email) async {
    final res = await _dio.post('/auth/send-otp', data: {'email': email});
    if (res.statusCode != 200) {
      throw Exception(res.data['error'] ?? 'Failed to send OTP');
    }
  }

  Future<void> verifyOtp(String email, String code) async {
    final res = await _dio.post('/auth/verify-otp', data: {
      'email': email,
      'code': code,
    });

    if (res.statusCode != 200) {
      throw Exception(res.data['error'] ?? 'Invalid OTP');
    }
  }
}
