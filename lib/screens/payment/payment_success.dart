import 'package:dental_care/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Success'),
        automaticallyImplyLeading: false, // To disable the back button
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 120, // Big success arrow
            ),
            SizedBox(height: 20),
            Text(
              'Payment Successful',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'Appointment has been booked successfully',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: () {
            Get.off(() => const MainScreen());
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(
                double.infinity, 50), // Full-width button at the bottom
          ),
          child: Text('Done'),
        ),
      ),
    );
  }
}
