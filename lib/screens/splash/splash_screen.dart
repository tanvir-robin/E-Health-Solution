import 'package:dental_care/constants.dart';
import 'package:dental_care/screens/auth/sign_in_screen.dart';
import 'package:dental_care/screens/auth/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatelessWidget {
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
                  Spacer(),
                  // SvgPicture.asset("assets/icons/gerda_logo.svg"),
                  Text(
                    'E-HealthCare',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Colors.white),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        )),
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFF6CD8D1),
                    ),
                    child: Text("Sign Up"),
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
                      child: Text("Sign In"),
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
