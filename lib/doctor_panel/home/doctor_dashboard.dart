import 'package:dental_care/doctor_panel/prescribe/doctor_prescribe.dart';
import 'package:dental_care/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_care/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorPanelScreen extends StatelessWidget {
  const DoctorPanelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appointmentsCollection =
        FirebaseFirestore.instance.collection('appointments');
    Set<String> uniquePatientIds = {};
    // Assume you have a collection for patients
    final patientsCollection =
        FirebaseFirestore.instance.collection('patients');

    return Scaffold(
      appBar: AppBar(
        title: Text("My Dental Clinic"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification Banner
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.amber[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Hello, ${loggedInDoctor!.name}",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),

              // Appointments Section
              Text(
                "Appointments",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: appointmentsCollection
                    .where('doctorId', isEqualTo: loggedInDoctor!.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  int todayCount = 0;
                  int upcomingCount = 0;

                  final now = DateTime.now();
                  final todayStart = DateTime(now.year, now.month, now.day);
                  final tomorrowStart = todayStart.add(Duration(days: 1));

                  for (var doc in snapshot.data!.docs) {
                    uniquePatientIds.add(doc['patientDocID']);
                    final appointmentDate =
                        (doc['dateTime'] as Timestamp).toDate();
                    if (appointmentDate.isAfter(todayStart) &&
                        appointmentDate.isBefore(tomorrowStart)) {
                      todayCount++;
                    }
                    if (appointmentDate.isAfter(now)) {
                      upcomingCount++;
                    }
                  }

                  return Column(
                    children: [
                      InkWell(
                          onTap: () {
                            Get.to(() => const DoctorAppointmentsScreen());
                          },
                          child: _buildAppointmentCard(
                              todayCount.toString(), "Today")),
                      _buildAppointmentCard(
                          upcomingCount.toString(), "Upcoming"),
                      Center(
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "View Device Calendar",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),

              // Patients Section
              Text(
                "Patients",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: patientsCollection.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final totalPatients = uniquePatientIds.length;
                  return Column(
                    children: [
                      _buildPatientCard(
                          totalPatients.toString(), "Total Patients"),
                      _buildPatientCard("0", "Total Patients for Re-call"),
                      _buildPatientCard("0", "Upcoming Birthdays"),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),

              // Shortcuts Section
              Text(
                "Shortcuts",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: [
                  _buildShortcutButton("Upgrade Now"),
                  _buildShortcutButton("Add Payment"),
                  _buildShortcutButton("Backup"),
                  InkWell(
                      onTap: () {
                        Get.to(() => SplashScreen());
                      },
                      child: _buildShortcutButton("Sign Out")),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(String count, String title) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(count, style: TextStyle(fontSize: 24)),
        subtitle: Text(title),
        trailing: Icon(Icons.arrow_forward),
      ),
    );
  }

  Widget _buildPatientCard(String count, String title) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(count, style: TextStyle(fontSize: 24)),
        subtitle: Text(title),
        trailing: Icon(Icons.arrow_forward),
      ),
    );
  }

  Widget _buildShortcutButton(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: null,
        child: Text(title),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          backgroundColor: Colors.blue, // Background color
          foregroundColor: Colors.white, // Text color
        ),
      ),
    );
  }
}
