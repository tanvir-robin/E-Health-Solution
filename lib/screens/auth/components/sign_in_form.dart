import 'package:dental_care/controllers/auth_controller.dart';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../../constants.dart';

class SignInForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

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
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (newValue) {},
                  decoration: InputDecoration(labelText: "Email*"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: TextFormField(
                    controller: authcontroller.passwordController,
                    validator: passwordValidator,
                    obscureText: true,
                    onSaved: (newValue) {},
                    decoration: InputDecoration(labelText: "Password*"),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text("Forgot your Password?"),
                ),
                SizedBox(height: defaultPadding),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        authcontroller.signInAccount(context);
                      }
                    },
                    child: Text("Sign In"),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
