import 'dart:math'; // For generating random OTP
import 'package:dental_care/helpers.dart';
import 'package:dental_care/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// OtpScreen with OTP verification
class OtpScreen extends StatefulWidget {
  final String recipientEmail;

  const OtpScreen({Key? key, required this.recipientEmail}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late String _generatedOtp;
  String _userOtp = "";

  @override
  void initState() {
    super.initState();
    _generatedOtp = _generateOtp();
    _sendOtp(widget.recipientEmail, _generatedOtp);
  }

  // Generate a random 6-digit OTP
  String _generateOtp() {
    Random random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  // Send OTP email
  Future<void> _sendOtp(String recipientEmail, String otp) async {
    EmailService emailService = EmailService();
    await emailService.sendOtpEmail(recipientEmail, otp);
  }

  // Handle OTP input change
  void _onOtpChanged(String otp) {
    setState(() {
      _userOtp = otp;

      // Automatically verify OTP if 6 digits are entered
      if (otp.length == 6) {
        _verifyOtp();
      }
    });
  }

  // Verify OTP and navigate to MainPage if valid
  void _verifyOtp() {
    if (_userOtp == _generatedOtp) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "OTP Verification",
          style: TextStyle(color: Color(0xFF757575)),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "OTP Verification",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Enter the OTP sent to your email. This code will expire in 00:30.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF757575)),
                  ),
                  const SizedBox(height: 20),
                  OtpForm(onOtpChanged: _onOtpChanged),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _userOtp.length == 6
                        ? _verifyOtp
                        : null, // Enable button if OTP is entered
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.blue, // Changed to blue
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                    child: const Text(
                      "Verify OTP",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OtpForm extends StatefulWidget {
  final Function(String) onOtpChanged;

  const OtpForm({Key? key, required this.onOtpChanged}) : super(key: key);

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Helper method to move focus to the next or previous input field
  void _nextField({required String value, required FocusNode focusNode}) {
    if (value.isNotEmpty) {
      focusNode.nextFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(6, (index) {
          return SizedBox(
            width: 48,
            height: 64,
            child: TextFormField(
              controller: _controllers[index],
              autofocus: index == 0,
              obscureText: false, // Show the text instead of password dots
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) {
                if (value.isNotEmpty && index < 5) {
                  _nextField(value: value, focusNode: FocusScope.of(context));
                }
                if (value.isEmpty && index > 0) {
                  FocusScope.of(context).previousFocus();
                }

                // Combine the inputs from all fields and pass to the parent
                String otp = _controllers.map((c) => c.text).join();
                widget.onOtpChanged(otp);
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
              ),
            ),
          );
        }),
      ),
    );
  }
}
