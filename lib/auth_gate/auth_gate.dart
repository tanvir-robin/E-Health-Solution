import 'package:dental_care/screens/splash/splash_screen.dart';
import 'package:dental_care/screens/main/main_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return SplashScreen();
          }
          return const MainScreen();
        });
  }
}
