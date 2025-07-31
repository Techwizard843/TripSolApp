// lib/auth_service.dart

class AuthService {
  Future<void> signInWithGoogle() async {
    print("Mock sign-in: Google user signed in");
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> signOut() async {
    print("Mock sign-out: User signed out");
    await Future.delayed(const Duration(milliseconds: 500));
  }

  String? get currentUserEmail => "mockuser@example.com";
}
