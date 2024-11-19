import 'package:dental_care/doctor_panel/chat/all_chat_doctor.dart';
import 'package:dental_care/doctor_panel/prescribe/doctor_prescribe.dart';
import 'package:dental_care/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_care/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorPanelScreen extends StatelessWidget {
  const DoctorPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appointmentsCollection =
        FirebaseFirestore.instance.collection('appointments');
    final patientsCollection =
        FirebaseFirestore.instance.collection('patients');

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Dental Clinic"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_sharp),
            onPressed: () {
              Get.to(() => DoctorAllMessages());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Greeting Section
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.blue,
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Welcome, Dr. ${loggedInDoctor!.name}!",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Appointments Section
              _buildSectionTitle("Appointments"),
              const SizedBox(height: 10),
              _buildAppointmentGrid(appointmentsCollection),

              const SizedBox(height: 20),

              // Patients Section
              _buildSectionTitle("Patients"),
              const SizedBox(height: 10),
              _buildPatientCard(patientsCollection),

              const SizedBox(height: 20),

              // Shortcuts Section
              _buildSectionTitle("Shortcuts"),
              const SizedBox(height: 10),
              GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                children: [
                  _buildShortcutTile("Messages", Icons.message,
                      () => Get.to(() => DoctorAllMessages())),
                  _buildShortcutTile("Sign Out", Icons.logout,
                      () => Get.to(() => SplashScreen())),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildAppointmentGrid(CollectionReference appointmentsCollection) {
    return StreamBuilder<QuerySnapshot>(
      stream: appointmentsCollection
          .where('doctorId', isEqualTo: loggedInDoctor!.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        int todayCount = 0;
        int upcomingCount = 0;

        final now = DateTime.now();
        final todayStart = DateTime(now.year, now.month, now.day);
        final tomorrowStart = todayStart.add(const Duration(days: 1));

        for (var doc in snapshot.data!.docs) {
          final appointmentDate = (doc['dateTime'] as Timestamp).toDate();
          if (appointmentDate.isAfter(todayStart) &&
              appointmentDate.isBefore(tomorrowStart)) {
            todayCount++;
          }
          if (appointmentDate.isAfter(now)) {
            upcomingCount++;
          }
        }

        return GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          children: [
            InkWell(
                onTap: () {
                  Get.to(() => DoctorAppointmentsScreen());
                },
                child: _buildInfoTile(
                    "Today", todayCount.toString(), Colors.green)),
            _buildInfoTile("Upcoming", upcomingCount.toString(), Colors.blue),
          ],
        );
      },
    );
  }

  Widget _buildInfoTile(String title, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildShortcutTile(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientCard(CollectionReference patientsCollection) {
    return StreamBuilder<QuerySnapshot>(
      stream: patientsCollection.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final totalPatients = snapshot.data!.docs.length;
        return _buildInfoTile(
            "Total Patients", totalPatients.toString(), Colors.orange);
      },
    );
  }
}
