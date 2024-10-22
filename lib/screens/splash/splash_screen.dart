import 'package:dental_care/constants.dart';
import 'package:dental_care/screens/auth/sign_in_screen.dart';
import 'package:dental_care/screens/auth/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(
            "assets/icons/splash_bg.svg",
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                children: [
                  const Spacer(),
                  // SvgPicture.asset("assets/icons/gerda_logo.svg"),
                  const Text(
                    'SmileNest',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Colors.white),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        )),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF6CD8D1),
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
