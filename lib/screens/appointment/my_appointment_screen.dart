import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_care/models/AvailableDoctor.dart';
import 'package:dental_care/screens/chat/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dental_care/constants.dart';

// Assuming you have the ChatScreen defined somewhere in your project

List<AvailableDoctor> demoAvailableDoctors = [
  AvailableDoctor(
    id: 1,
    name: "Dr. Md. Imran Hossain",
    sector: "Orthodontist",
    experience: 8,
    patients: '1.08K',
    image: "assets/images/doc1.webp",
    degrees:
        '''BDS (DU), PhD (Dental Surgery) France, MSS (Clinical) DU, MPH (USA),
PGT (Orthodontic), PGT (OMS) BSMMU, Research Fellow & Surgeon (STRC Project, Smile Train, USA),
Advanced Implantology (Thailand), Invisalign (Thailand & India),
Advanced Training in Fixed Orthodontic Braces, Implantology & Laser Dentistry (India)''',
    email: "doc1@gmail.com",
    password: "password1",
  ),
  AvailableDoctor(
    id: 2,
    name: "Prof. Dr. B.A.K Azad",
    sector: "OMS",
    experience: 5,
    patients: '2.7K',
    image: "assets/images/doc2.jpeg",
    degrees: '''BDS, DDS, MCPS, MDS (London), FICP (America)''',
    email: "doc2@gmail.com",
    password: "password2",
  ),
  AvailableDoctor(
    id: 3,
    name: "Dr. Proshenjit Sarker",
    sector: "OMS, Endodontist",
    experience: 5,
    patients: '2.7K',
    image: "assets/images/doc3.webp",
    degrees:
        '''BDS (Dhaka Dental College), PGT (Oral & Maxillofacial Surgery), PGT (Conservative & Endodontics),
PGT (Prosthodontics), Specialized Training on Dental Implant (DGME),
Specialized Training on Aesthetic Dentistry (DGHS), Training On Cross Infection (DGHS)''',
    email: "doc3@gmail.comm",
    password: "password3",
  ),
  AvailableDoctor(
    id: 4,
    name: "Dr. Roksana Begum",
    sector: "Pedodontist, DPH",
    experience: 5,
    patients: '2.7K',
    image: "assets/images/doc4.png",
    degrees: '''BDS (DDC), PGT (MOHKSA)''',
    email: "doc4@gmail.comm",
    password: "password4",
  ),
  AvailableDoctor(
    id: 5,
    name: "Dr. Farzana Anar",
    sector: "Periodontist, Orthodontist",
    experience: 5,
    patients: '2.7K',
    image: "assets/images/doc5.jpg",
    degrees: '''BDS, FCPS, Conservative Dentistry & Endodontics Specialist''',
    email: "doc5@gmail.com",
    password: "password5",
  ),
];

class MyAppointmentScreen extends StatelessWidget {
  const MyAppointmentScreen({super.key});

  Stream<List<Map<String, dynamic>>> fetchAppointmentsStream() {
    return FirebaseFirestore.instance
        .collection('appointments')
        .where('patientDocID',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
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
        password: '',
        email: '',
        degrees: '',
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
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .update({'status': 'Cancelled'});

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment cancelled successfully!')),
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
            title: const Text('Prescription'),
            content: SingleChildScrollView(
              child: Text(
                prescription,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
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
        title: const Text("My Appointments"),
      ),
      body: SafeArea(
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: fetchAppointmentsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text("Error fetching appointments"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No appointments available"));
            }

            final appointments = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(defaultPadding),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                final doctorId = appointment['doctorId'] as int;
                final doctor = findDoctor(doctorId);
                final appointmentDate =
                    (appointment['dateTime'] as Timestamp).toDate();
                final appointmentStatus = appointment['status'];
                bool isPescribed =
                    appointment['status'] == 'prescribed' ? true : false;
                bool isExpired = DateTime.now().isAfter(appointmentDate);
                bool isCancelled = appointmentStatus == 'Cancelled';
                bool isCancellable = (appointmentStatus == 'pending' ||
                    appointmentStatus == 'Upcoming');

                return Container(
                  margin: const EdgeInsets.only(bottom: defaultPadding),
                  padding: const EdgeInsets.all(defaultPadding),
                  decoration: const BoxDecoration(
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
                          const SizedBox(width: defaultPadding),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doctor.name,
                                  style: const TextStyle(
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
                      const SizedBox(height: defaultPadding),
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
                      const Divider(height: defaultPadding * 2),
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
                                    child: const Text("Cancel"),
                                  )
                                // Show the Chat button if the appointment is expired
                                else
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
                                    icon: const Icon(Icons.chat),
                                    label: const Text('Chat'),
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
          style: const TextStyle(
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          info,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
