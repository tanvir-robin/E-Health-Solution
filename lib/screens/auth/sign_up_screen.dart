import 'package:dental_care/constants.dart';
import 'package:flutter/material.dart';

import 'components/sign_up_form.dart';
import 'sign_in_screen.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sign Up",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text("Already have an account?"),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignInScreen(),
                      ),
                    ),
                    child: Text("Sign In!"),
                  )
                ],
              ),
              SizedBox(height: defaultPadding * 1.5),
              SignUpForm(),
            ],
          ),
        ),
      ),
    );
  }
}
