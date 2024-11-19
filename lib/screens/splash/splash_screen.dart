import 'package:dental_care/constants.dart';
import 'package:dental_care/screens/auth/sign_in_screen.dart';
import 'package:dental_care/screens/auth/sign_up_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 67, 54, 183),
                  Color.fromARGB(255, 129, 114, 216)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                children: [
                  const Spacer(),
                  const Text(
                    'Smart Health Care',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Colors.black),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        )),
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 0, 3, 2),
                    ),
                    child: const Text("Sign Up"),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultPadding),
                    child: OutlinedButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignInScreen(),
                        ),
                      ),
                      child: const Text("Sign In"),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
