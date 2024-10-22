import 'package:dental_care/constants.dart';
import 'package:dental_care/doctor_panel/home/doctor_dashboard.dart';
import 'package:dental_care/globals.dart';
import 'package:dental_care/models/AvailableDoctor.dart';
import 'package:dental_care/screens/auth/sign_in_screen.dart';
import 'package:dental_care/screens/auth/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorSignInScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  DoctorSignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sign In as a Doctor",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: defaultPadding * 1.5),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: "Email*"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: defaultPadding),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration:
                            const InputDecoration(labelText: "Password*"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your password";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _loginDoctor();
                          }
                        },
                        child: const Text("Sign In"),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: TextButton(
                          onPressed: () {
                            Get.off(() => SignInScreen());
                          },
                          child: const Text(
                            'Patient Sign In',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 17),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loginDoctor() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    for (var doctor in demoAvailableDoctors) {
      if (doctor.email == email && doctor.password == password) {
        loggedInDoctor = doctor;
        Get.offAll(() => const DoctorPanelScreen());
        return;
      }
    }

    Get.snackbar("Login Failed", "Invalid email or password",
        snackPosition: SnackPosition.BOTTOM);
  }
}
