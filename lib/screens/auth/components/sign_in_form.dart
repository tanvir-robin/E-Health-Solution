import 'package:dental_care/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../../constants.dart';

class SignInForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  SignInForm({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (authcontroller) {
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: authcontroller.emailController,
                  validator: MultiValidator(
                    [
                      RequiredValidator(errorText: requiredField),
                      EmailValidator(errorText: emailError),
                    ],
                  ).call,
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (newValue) {},
                  decoration: const InputDecoration(labelText: "Email*"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: TextFormField(
                    controller: authcontroller.passwordController,
                    validator: passwordValidator.call,
                    obscureText: true,
                    onSaved: (newValue) {},
                    decoration: const InputDecoration(labelText: "Password*"),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // final TextEditingController emailController = TextEditingController();
                        return AlertDialog(
                          title: const Text("Forgot Password"),
                          content: TextFormField(
                            controller: authcontroller.emailController,
                            validator: MultiValidator(
                              [
                                RequiredValidator(errorText: requiredField),
                                EmailValidator(errorText: emailError),
                              ],
                            ).call,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                labelText: "Enter your email"),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                if (authcontroller
                                    .emailController.text.isNotEmpty) {
                                  authcontroller.resetPassword(context);
                                  Navigator.of(context).pop();
                                }
                              },
                              child: const Text("Submit"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text("Forgot your Password?"),
                ),
                const SizedBox(height: defaultPadding),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        authcontroller.signInAccount(context);
                      }
                    },
                    child: const Text("Sign In"),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
