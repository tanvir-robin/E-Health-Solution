import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_care/screens/chat/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dental_care/constants.dart';

// Assuming you have the ChatScreen defined somewhere in your project

class AvailableDoctor {
  final int id;
  final String name;
  final String sector;
  final int experience;
  final String patients;
  final String image;

  AvailableDoctor({
    required this.id,
    required this.name,
    required this.sector,
    required this.experience,
    required this.patients,
    required this.image,
  });
}

List<AvailableDoctor> demoAvailableDoctors = [
  AvailableDoctor(
    id: 1,
    name: "Dr. Sumaiya Rahamn",
    sector: "Medicine Specialist",
    experience: 8,
    patients: '1.08K',
    image: "assets/images/Serena_Gome.png",
  ),
  AvailableDoctor(
    id: 2,
    name: "Dr. Asma Khan",
    sector: "Medicine Specialist",
    experience: 5,
    patients: '2.7K',
    image: "assets/images/Asma_Khan.png",
  ),
  AvailableDoctor(
    id: 3,
    name: "Dr. Kiran Shakia",
    sector: "Medicine Specialist",
    experience: 5,
    patients: '2.7K',
    image: "assets/images/Kiran_Shakia.png",
  ),
  AvailableDoctor(
    id: 4,
    name: "Dr. Masuda Khan",
    sector: "Medicine Specialist",
    experience: 5,
    patients: '2.7K',
    image: "assets/images/Masuda_Khan.png",
  ),
  AvailableDoctor(
    id: 5,
    name: "Dr. Johir Raihan",
    sector: "Medicine Specialist",
    experience: 5,
    patients: '2.7K',
    image: "assets/images/Johir_Raihan.png",
  ),
];

class MyAppointmentScreen extends StatelessWidget {
  const MyAppointmentScreen({Key? key}) : super(key: key);

  Stream<List<Map<String, dynamic>>> fetchAppointmentsStream() {
    return FirebaseFirestore.instance
        .collection('appointments')
        .where('patientDocID',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return {
                'id': doc.id,
                ...data,
              };
            }).toList());
  }

  AvailableDoctor findDoctor(int doctorId) {
    return demoAvailableDoctors.firstWhere(
      (doc) => doc.id == doctorId,
      orElse: () => AvailableDoctor(
        id: 0,
        name: "Unknown Doctor",
        sector: "",
        experience: 0,
        patients: "",
        image: "",
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return "${dateTime.hour % 12}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}";
  }

  Future<void> _cancelAppointment(
      BuildContext context, String appointmentId) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .update({'status': 'Cancelled'});

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment cancelled successfully!')),
      );
    } catch (e) {
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cancelling appointment: $e')),
      );
    }
  }

  Future<void> _showPrescription(
      BuildContext context, String appointmentId) async {
    try {
      final appointmentDoc = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .get();

      final prescription = appointmentDoc['prescription'] as String?;

      if (prescription != null && prescription.isNotEmpty) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Prescription'),
            content: SingleChildScrollView(
              child: Text(
                prescription,
                style: TextStyle(fontSize: 16),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('No prescription found for this appointment.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching prescription: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Appointments"),
      ),
      body: SafeArea(
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: fetchAppointmentsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error fetching appointments"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No appointments available"));
            }

            final appointments = snapshot.data!;

            return ListView.builder(
              padding: EdgeInsets.all(defaultPadding),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                final doctorId = appointment['doctorId'] as int;
                final doctor = findDoctor(doctorId);
                final appointmentDate =
                    (appointment['dateTime'] as Timestamp).toDate();
                final appointmentStatus = appointment['status'];

                bool isExpired = DateTime.now().isAfter(appointmentDate);
                bool isCancelled = appointmentStatus == 'Cancelled';
                bool isCancellable = (appointmentStatus == 'pending' ||
                    appointmentStatus == 'Upcoming');

                return Container(
                  margin: EdgeInsets.only(bottom: defaultPadding),
                  padding: EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.all(Radius.circular(defaultPadding / 2)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(doctor.image),
                            backgroundColor: Colors.grey[200],
                          ),
                          SizedBox(width: defaultPadding),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doctor.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  doctor.sector,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: textColor.withOpacity(0.6),
                                  ),
                                ),
                                Text(
                                  "Experience: ${doctor.experience} years",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: textColor.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: defaultPadding),
                      Row(
                        children: [
                          Expanded(
                            child: buildAppointmentInfo("Date",
                                "${appointmentDate.day}/${appointmentDate.month}/${appointmentDate.year}"),
                          ),
                          Expanded(
                            child: buildAppointmentInfo(
                                "Time", _formatTime(appointmentDate)),
                          ),
                          Expanded(
                            child: buildAppointmentInfo("Doctor", doctor.name),
                          ),
                        ],
                      ),
                      Divider(height: defaultPadding * 2),
                      Row(
                        children: [
                          Expanded(
                            child: buildAppointmentInfo("Type", "Dentist"),
                          ),
                          Expanded(
                            child: buildAppointmentInfo("Place", "City Clinic"),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                // Show the Cancel button if the appointment is future
                                if (!isExpired && isCancellable)
                                  ElevatedButton(
                                    onPressed: () {
                                      _cancelAppointment(
                                          context, appointment['id']);
                                    },
                                    style: TextButton.styleFrom(
                                        backgroundColor: redColor),
                                    child: Text("Cancel"),
                                  )
                                // Show the Chat button if the appointment is expired
                                else if (isExpired)
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                            doctorId: doctorId,
                                            patientId: FirebaseAuth
                                                .instance.currentUser!.uid,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.chat),
                                    label: Text('Chat'),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget buildAppointmentInfo(String title, String info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black54,
          ),
        ),
        SizedBox(height: 4),
        Text(
          info,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
