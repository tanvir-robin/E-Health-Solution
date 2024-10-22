import 'package:dental_care/constants.dart';
import 'package:dental_care/models/AvailableDoctor.dart';
import 'package:dental_care/screens/appointment/cpmponents/calendar.dart';
import 'package:dental_care/screens/appointment/models/appointment_model.dart';
import 'package:dental_care/screens/main/main_screen.dart';
import 'package:dental_care/screens/payment/payment_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key, required this.doctor});
  final AvailableDoctor doctor;

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final List<String> slots = [
    "10:00 am",
    "11:00 am",
    "12:00 pm",
    "1:00 pm",
    "2:00 pm",
    "3:00 pm",
    "4:00 pm",
    "5:00 pm",
  ];

  int selectedSlot = 0;
  DateTime? selectedDate =
      DateTime.now(); // Set the initial selected date to today's date
  final TextEditingController complaintController =
      TextEditingController(); // Controller for complaint

  // Function to fetch booked slots for the doctor
  Future<List<String>> fetchBookedSlots(int doctorId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .get();

    List<String> bookedSlots = [];
    for (var doc in snapshot.docs) {
      Appointment appointment =
          Appointment.fromJson(doc.data() as Map<String, dynamic>);
      // Check if the appointment date matches the selected date
      if (appointment.dateTime.year == selectedDate!.year &&
          appointment.dateTime.month == selectedDate!.month &&
          appointment.dateTime.day == selectedDate!.day) {
        String timeSlot = _formatTimeToSlot(appointment.dateTime);
        bookedSlots.add(timeSlot);
      }
    }
    return bookedSlots;
  }

  // Function to format DateTime to time slot
  String _formatTimeToSlot(DateTime dateTime) {
    String hour = dateTime.hour.toString();
    String minute = dateTime.minute == 0 ? "00" : dateTime.minute.toString();
    String period = dateTime.hour >= 12 ? "pm" : "am";

    if (dateTime.hour > 12) {
      hour = (dateTime.hour - 12).toString();
    } else if (dateTime.hour == 0) {
      hour = "12"; // Midnight case
    }

    return "$hour:$minute $period";
  }

  // Function to book the appointment
  void bookAppointment(String patientDocID, int doctorId, DateTime selectedDate,
      String selectedTime, String complaint) async {
    // Add complaint parameter
    EasyLoading.show(status: 'Booking Appointment...');

    // Split the selectedTime into hours and minutes
    List<String> timeParts = selectedTime.split(" ");
    List<String> hourMinute = timeParts[0].split(":");

    int hour = int.parse(hourMinute[0]);
    int minute = int.parse(hourMinute[1]);

    // If time is in PM and it's not 12 PM, add 12 to convert to 24-hour format
    if (timeParts[1] == "pm" && hour != 12) {
      hour += 12;
    }

    // If it's 12 AM, set the hour to 0 (midnight)
    if (timeParts[1] == "am" && hour == 12) {
      hour = 0;
    }

    // Now, create the correct DateTime object
    DateTime appointmentDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      hour,
      minute,
    );

    Appointment appointment = Appointment(
      patientDocID: patientDocID,
      doctorId: doctorId,
      dateTime: appointmentDateTime,
      status: "pending",
      complaint: complaint, // Assign the complaint
    );

    EasyLoading.dismiss();

    Get.to(() => PaymentPage(
          doctor: widget.doctor,
          appointment: appointment,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointment"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Calendar(
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Text(
                "Slots",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: FutureBuilder<List<String>>(
                future: fetchBookedSlots(
                    widget.doctor.id), // Fetch all booked slots for the doctor
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text("Error loading slots."));
                  }

                  List<String> bookedSlots = snapshot.data ?? [];

                  return GridView.builder(
                    shrinkWrap: true,
                    itemCount: slots.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2.77,
                      mainAxisSpacing: defaultPadding,
                      crossAxisSpacing: defaultPadding,
                    ),
                    itemBuilder: (context, index) {
                      bool isBooked = bookedSlots.contains(slots[index]);
                      return GestureDetector(
                        onTap: isBooked
                            ? null
                            : () {
                                setState(() {
                                  selectedSlot = index;
                                });
                              },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isBooked
                                ? Colors.grey
                                : (selectedSlot == index
                                    ? primaryColor
                                    : Colors.white),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6)),
                          ),
                          child: Text(
                            isBooked ? 'Taken' : slots[index],
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color: isBooked
                                        ? const Color.fromARGB(255, 81, 22, 18)
                                        : (selectedSlot == index
                                            ? Colors.white
                                            : textColor)),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Text(
                "Cheif Complaints",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: TextField(
                controller: complaintController,
                maxLines: 5, // Multiline input
                decoration: const InputDecoration(
                  hintText: "Enter your complaint here...",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: ElevatedButton(
                onPressed: () {
                  String patientDocID = FirebaseAuth.instance.currentUser!.uid;
                  int doctorId = widget.doctor.id;

                  if (selectedDate != null) {
                    String selectedTime = slots[selectedSlot];
                    String complaint =
                        complaintController.text; // Get complaint text
                    bookAppointment(patientDocID, doctorId, selectedDate!,
                        selectedTime, complaint);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select a date.")),
                    );
                  }
                },
                child: const Text("Confirm Appointment"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
