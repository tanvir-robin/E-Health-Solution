import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_care/components/toast_services.dart';
import 'package:dental_care/models/UserModel.dart';
import 'package:dental_care/screens/auth/otp_verification_screen.dart';
import 'package:dental_care/screens/main/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AuthController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNamedController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  final fbAuth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  Future<void> createUserAccount(BuildContext context) async {
    try {
      EasyLoading.show(status: 'Loading...');
      final UserCredential userCredential =
          await fbAuth.createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      UserModel user = UserModel(
          username: userNamedController.text,
          email: emailController.text,
          phone: phoneController.text,
          createdAt: DateTime.now());
      if (userCredential.user == null) {
        ToastService().showErrorToast(context, 'Sorry, Something Went Wrong!');
        EasyLoading.dismiss();
        return;
      }
      await db
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(user.toJSON());

      EasyLoading.dismiss();
      ToastService().showSuccessToast(context, 'Account Created Successfully');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpScreen(
            recipientEmail: emailController.text,
          ),
        ),
      );
    } catch (e) {
      print(e);
      ToastService().showErrorToast(context, 'Sorry, Something Went Wrong!');
      EasyLoading.dismiss();
    }
  }

  Future<void> signInAccount(BuildContext context) async {
    try {
      EasyLoading.show(status: 'Signin in...');
      final UserCredential userCredential =
          await fbAuth.signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);

      if (userCredential.user == null) {
        ToastService().showErrorToast(context, 'Sorry, Something Went Wrong!');
        EasyLoading.dismiss();
        return;
      }

      EasyLoading.dismiss();
      ToastService().showSuccessToast(context, 'Logged In Successfully');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
      );
    } catch (e) {
      print(e);
      ToastService().showErrorToast(context, 'Sorry, Something Went Wrong!');
      EasyLoading.dismiss();
    }
  }
}
