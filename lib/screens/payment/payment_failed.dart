import 'package:dental_care/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentFailedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 120,
            ),
            SizedBox(height: 20),
            Text(
              'Payment Failed',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: () {
            Get.off(() => MainScreen());
          },
          child: Text('Retry'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
            backgroundColor: Colors.red,
          ),
        ),
      ),
    );
  }
}
