
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_repository.dar.dart';


final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // Swap to FirebaseAuthRepository when ready.
  return FakeAuthRepository();
});
