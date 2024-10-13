import 'package:dental_care/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../../constants.dart';

class SignUpForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String _password = "";
    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (authcontroller) {
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: authcontroller.userNamedController,
                  validator: RequiredValidator(errorText: requiredField),
                  onSaved: (newValue) {},
                  decoration: InputDecoration(labelText: "Username*"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: TextFormField(
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
                ),
                TextFormField(
                  controller: authcontroller.phoneController,
                  onSaved: (newValue) {},
                  decoration: InputDecoration(labelText: "Phone Number"),
                  keyboardType: TextInputType.phone,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: TextFormField(
                    controller: authcontroller.passwordController,
                    validator: passwordValidator,
                    obscureText: true,
                    onChanged: (value) => _password = value,
                    onSaved: (pass) {},
                    decoration: InputDecoration(labelText: "Password*"),
                  ),
                ),
                TextFormField(
                  validator: (val) =>
                      MatchValidator(errorText: 'passwords do not match')
                          .validateMatch(val!, _password),
                  obscureText: true,
                  onSaved: (newValue) {},
                  decoration: InputDecoration(labelText: "Confirm password*"),
                ),
                SizedBox(height: defaultPadding * 1.5),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        authcontroller.createUserAccount(context);
                      }
                    },
                    child: Text("Sign Up"),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
