import 'dart:io';

import 'package:dental_care/doctor_panel/components/pescription_pdf.dart';
import 'package:dental_care/globals.dart';
import 'package:dental_care/helpers.dart';
import 'package:dental_care/models/AvailableDoctor.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DoctorAppointmentsScreen extends StatelessWidget {
  const DoctorAppointmentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appointmentsCollection =
        FirebaseFirestore.instance.collection('appointments');

    return Scaffold(
      appBar: AppBar(
        title: Text("My Appointments"),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: appointmentsCollection
            .where('doctorId', isEqualTo: loggedInDoctor!.id)
            .where('status', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final appointments = snapshot.data!.docs;

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              final patientDocID = appointment['patientDocID'];

              return _buildAppointmentCard(appointment, patientDocID, context);
            },
          );
        },
      ),
    );
  }

  Widget _buildAppointmentCard(
      DocumentSnapshot appointment, String patientDocID, BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(patientDocID)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const ListTile(
            title: Text("Loading patient details..."),
          );
        }

        final patient = snapshot.data!;
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient['username'] ?? "Unknown Patient",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4), // Add some space between texts
                Text("Complaint: ${appointment['complaint']}"),
                SizedBox(height: 4), // Add some space between texts
                Text("Date: ${appointment['dateTime'].toDate()}"),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () =>
                        _showPastRecords(context, appointment['patientDocID']),
                    child: Text("Past Appointments"),
                  ),
                ),
                // Add some space before the button

                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () =>
                        _showPrescriptionDialog(context, appointment.id),
                    child: Text("Prescribe Now"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPrescriptionDialog(BuildContext context, String appointmentId) {
    final prescriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Write Prescription"),
          content: TextField(
            controller: prescriptionController,
            maxLines: 5,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter prescription details...",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _prescribeMedication(
                    appointmentId, prescriptionController.text);
                Navigator.pop(context);
              },
              child: Text("Send"),
            ),
          ],
        );
      },
    );
  }

  void _prescribeMedication(String appointmentId, String prescription) async {
    final appointmentsCollection =
        FirebaseFirestore.instance.collection('appointments');

    // Get patient email for sending the prescription
    final appointment = await appointmentsCollection.doc(appointmentId).get();
    final patientDocID = appointment['patientDocID'];
    final patientSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(patientDocID)
        .get();
    final patientEmail = patientSnapshot['email'];

    // Find the doctor using the doctorId
    final doctorId = appointment['doctorId'] as int?;
    final doctor = demoAvailableDoctors.firstWhere((doc) => doc.id == doctorId,
        orElse: () => AvailableDoctor(
            id: 0,
            name: "Unknown Doctor",
            sector: "N/A",
            experience: 0,
            patients: 'N/A',
            image: "",
            email: "",
            password: ""));

    // Update Firestore with the prescription
    await appointmentsCollection.doc(appointmentId).update({
      'prescription': prescription,
      'status': 'prescribed',
    }).then((_) async {
      print("Prescription added successfully!");

      // Generate PDF with prescription details
      File pdfFile = await generatePrescriptionPDF(
        patientSnapshot[
            'username'], // Assuming the patient's name is stored as 'username'
        appointment['complaint'],
        doctor.name,
        prescription, // Pass the prescription details here
      );

      // Send prescription email
      final emailService = EmailService();
      await emailService.sendPrescriptionEmail(
          patientEmail, pdfFile, patientSnapshot['username']);
    }).catchError((error) {
      print("Failed to add prescription: $error");
    });
  }

  void _showPastRecords(BuildContext context, String patientDocID) {
    final pastAppointmentsCollection =
        FirebaseFirestore.instance.collection('appointments');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Past Appointments"),
          content: FutureBuilder<QuerySnapshot>(
            future: pastAppointmentsCollection
                .where('patientDocID', isEqualTo: patientDocID)
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox(
                  height: 100,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final pastAppointments = snapshot.data!.docs;

              if (pastAppointments.isEmpty) {
                return const SizedBox(
                  height: 100,
                  child: Center(child: Text("No past appointments found.")),
                );
              }

              return SizedBox(
                height: 300,
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: pastAppointments.length,
                  itemBuilder: (context, index) {
                    final appointment = pastAppointments[index];
                    final prescription =
                        (appointment.data() as Map<String, dynamic>)
                                .containsKey('prescription')
                            ? appointment['prescription']
                            : "N/A";

                    // Find the doctor using the doctorId
                    final doctorId = appointment['doctorId'] as int?;
                    final doctor = demoAvailableDoctors.firstWhere(
                        (doc) => doc.id == doctorId,
                        orElse: () => AvailableDoctor(
                            id: 0,
                            name: "Unknown Doctor",
                            sector: "N/A",
                            experience: 0,
                            patients: 'N/A',
                            image: "",
                            email: "",
                            password: ""));

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(
                          "Date: ${DateFormat("dd MMM, hh:mm a").format(appointment['dateTime'].toDate())}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Doctor: ${doctor.name} (${doctor.sector})"),
                            Text("Complaint: ${appointment['complaint']}"),
                            Text("Prescription: $prescription"),
                            Text("Status: ${appointment['status']}"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
