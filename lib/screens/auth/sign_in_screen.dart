import 'package:dental_care/constants.dart';
import 'package:dental_care/doctor_panel/auth/sign_in.dart';
import 'package:dental_care/screens/auth/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import 'components/sign_in_form.dart';

class SignInScreen extends StatelessWidget {
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
                "Sign In",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text("Don’n have an account?"),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpScreen(),
                      ),
                    ),
                    child: Text("Sign up!"),
                  )
                ],
              ),
              SignInForm(),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: TextButton(
                    onPressed: () {
                      Get.off(() => DoctorSignInScreen());
                    },
                    child: const Text(
                      'Doctor Sign In',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
