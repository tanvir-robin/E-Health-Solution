import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

class ToastService {
  // Singleton instance
  static final ToastService _instance = ToastService._internal();

  // Private constructor
  ToastService._internal();

  // Factory constructor to return the singleton instance
  factory ToastService() => _instance;

  // Success Toast
  void showSuccessToast(BuildContext context, String msg) {
    MotionToast.success(
      title: const Text("Success"),
      description: Text(msg),
      animationType: AnimationType.fromTop,
      position: MotionToastPosition.bottom,
      dismissable: true,
    ).show(context);
  }

  // Error Toast
  void showErrorToast(BuildContext context, String msg) {
    MotionToast.error(
      title: const Text("Error"),
      description: Text(msg),
      animationType: AnimationType.fromTop,
      position: MotionToastPosition.bottom,
      dismissable: true,
    ).show(context);
  }

  // Warning Toast
  void showWarningToast(BuildContext context, String msg) {
    MotionToast.warning(
      title: const Text("Warning"),
      description: Text(msg),
      animationType: AnimationType.fromTop,
      position: MotionToastPosition.bottom,
      dismissable: true,
    ).show(context);
  }

  // Info Toast
  void showInfoToast(BuildContext context, String msg) {
    MotionToast.info(
      title: const Text("Info"),
      description: Text(msg),
      animationType: AnimationType.fromTop,
      position: MotionToastPosition.bottom,
      dismissable: true,
    ).show(context);
  }

  // Customizable Toast
  void showCustomToast({
    required BuildContext context,
    required String msg,
    required Color backgroundColor,
    required IconData icon,
    required String title,
  }) {
    MotionToast(
      icon: icon,
      primaryColor: backgroundColor,
      title: Text(title),
      description: Text(msg),
      animationType: AnimationType.fromTop,
      position: MotionToastPosition.bottom,
      dismissable: true,
    ).show(context);
  }
}
