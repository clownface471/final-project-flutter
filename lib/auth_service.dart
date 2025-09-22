import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // GETTER untuk mendapatkan user yang sedang login
  User? get currentUser => _auth.currentUser;

  // Stream untuk memantau perubahan status autentikasi
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  // Fungsi untuk sign up
  Future<User?> signUpWithEmailPassword(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
      return credential.user;
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print('Firebase Auth Exception: ${e.message}');
      rethrow;
    } catch (e) {
      // ignore: avoid_print
      print('An unexpected error occurred: $e');
      rethrow;
    }
  }

  // Fungsi untuk sign in
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
      return credential.user;
    } catch (e) {
      rethrow;
    }
  }

  // Fungsi untuk sign out
  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }
}

