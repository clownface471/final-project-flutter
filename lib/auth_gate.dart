import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_page.dart'; // Import halaman utama 
import 'main.dart'; // Import halaman login 

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        // Mendengarkan perubahan status autentikasi dari Firebase
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // 1. Jika masih dalam proses pengecekan, tampilkan loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Jika user sudah login (data snapshot tidak null)
          if (snapshot.hasData) {
            // Arahkan ke Halaman Utama
            return const HomePage();
          }

          // 3. Jika user belum login (data snapshot adalah null)
          else {
            // Arahkan ke Halaman Login
            return const LoginPage();
          }
        },
      ),
    );
  }
}
