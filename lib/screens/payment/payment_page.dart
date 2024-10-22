import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dental_care/helpers.dart';
import 'package:dental_care/models/AvailableDoctor.dart';
import 'package:dental_care/screens/appointment/models/appointment_model.dart';
import 'package:dental_care/screens/payment/payment_failed.dart';
import 'package:dental_care/screens/payment/payment_receipt.dart';
import 'package:dental_care/screens/payment/payment_success.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';

class PaymentPage extends StatefulWidget {
  final AvailableDoctor doctor;
  final Appointment appointment;

  const PaymentPage(
      {super.key, required this.doctor, required this.appointment});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final double payableAmount = 600.0;
  PaymentReceipt paymentReceipt = PaymentReceipt();
  bool isLoading = false;

  Future<void> payNow() async {
    setState(() {
      isLoading = true;
    });

    // Initialize SSLCommerz
    Sslcommerz sslcommerz = Sslcommerz(
      initializer: SSLCommerzInitialization(
        multi_card_name: "visa,master,bkash",
        currency: SSLCurrencyType.BDT,
        product_category: "Health",
        sdkType: SSLCSdkType.TESTBOX,
        store_id: "algor670ab401dbbcc",
        store_passwd: "algor670ab401dbbcc@ssl",
        total_amount: payableAmount,
        tran_id: DateTime.now().millisecondsSinceEpoch.toString(),
      ),
    );

    // Perform the payment
    final res = await sslcommerz.payNow();

    // Get current user data
    User? currentUser = FirebaseAuth.instance.currentUser;

    // Transaction data to save in Firestore
    Map<String, dynamic> transactionData = {
      'user': currentUser!.uid,
      'email': currentUser.email,
      'time': Timestamp.now(),
      'status': res.status,
      'tran_id': res.tranId,
      'amount': res.amount,
      'card_type': res.cardType,
      'bank_tran_id': res.bankTranId,
    };

    // Save the transaction to Firestore
    await FirebaseFirestore.instance
        .collection('transactions')
        .add(transactionData);

    if (res.status == 'VALID') {
      // Add the appointment to Firestore
      await FirebaseFirestore.instance
          .collection('appointments')
          .add(widget.appointment.toJson());

      // Generate and send payment receipt
      File receiptFile = await paymentReceipt.generateReceiptPdf(res.toJson());
      await EmailService().sendInvoiceEmail(
          FirebaseAuth.instance.currentUser!.email!, receiptFile);

      // Navigate to Payment Success screen
      Get.to(() => PaymentSuccessScreen());
    } else {
      // Navigate to Payment Failed screen
      Get.to(() => PaymentFailedScreen());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade300, Colors.blue.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Doctor:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Hero(
                  tag: widget.doctor.id,
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      widget.doctor.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Payable Amount:",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    "$payableAmount BDT",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(thickness: 2),
                const Text(
                  "Appointment Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  "Date: ${DateFormat("dd MMM").format(widget.appointment.dateTime)}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  "Time: ${DateFormat("hh:mm a").format(widget.appointment.dateTime)}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const Text(
                  "Location: SmileNest",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                if (isLoading) const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : payNow,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              backgroundColor: isLoading ? Colors.grey : Colors.blue.shade600,
            ),
            child: Text(
              isLoading ? "Processing..." : "Pay Now",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
