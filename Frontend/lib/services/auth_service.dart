import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'https://tripsol-backend.onrender.com';

  /// Login using Google OAuth and send token to backend
  static Future<void> loginWithOAuth(
    String email,
    String name,
    String idToken,
  ) async {
    final url = Uri.parse('$baseUrl/oauth-login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'name': name, 'idToken': idToken}),
    );

    if (response.statusCode == 200) {
      print("✅ OAuth login successful");
    } else {
      print("❌ OAuth login failed: ${response.body}");
      throw Exception('OAuth login failed');
    }
  }

  /// Google Sign-In + backend login
  static Future<void> signInWithGoogle(BuildContext context) async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return;

      final auth = await account.authentication;
      final idToken = auth.idToken;
      final email = account.email;
      final name = account.displayName ?? '';

      if (idToken == null) {
        throw Exception("Google ID token is null");
      }

      await loginWithOAuth(email, name, idToken);

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Google Sign-In failed: $e")));
      }
      print("❌ Google Sign-In error: $e");
    }
  }

  static Future<void> signOut() async {
    print("User signed out");
    await Future.delayed(const Duration(milliseconds: 500));
  }

  static String? get currentUserEmail => null;
}
