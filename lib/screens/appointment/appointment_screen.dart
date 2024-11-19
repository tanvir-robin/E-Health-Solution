import 'package:dental_care/constants.dart';
import 'package:dental_care/models/AvailableDoctor.dart';
import 'package:dental_care/screens/appointment/cpmponents/calendar.dart';
import 'package:dental_care/screens/appointment/models/appointment_model.dart';
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
  DateTime? selectedDate = DateTime.now();
  final TextEditingController complaintController = TextEditingController();

  Future<List<String>> fetchBookedSlots(int doctorId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .get();

    List<String> bookedSlots = [];
    for (var doc in snapshot.docs) {
      Appointment appointment =
          Appointment.fromJson(doc.data() as Map<String, dynamic>);
      if (appointment.dateTime.year == selectedDate!.year &&
          appointment.dateTime.month == selectedDate!.month &&
          appointment.dateTime.day == selectedDate!.day) {
        String timeSlot = _formatTimeToSlot(appointment.dateTime);
        bookedSlots.add(timeSlot);
      }
    }
    return bookedSlots;
  }

  String _formatTimeToSlot(DateTime dateTime) {
    String hour = dateTime.hour.toString();
    String minute = dateTime.minute == 0 ? "00" : dateTime.minute.toString();
    String period = dateTime.hour >= 12 ? "pm" : "am";

    if (dateTime.hour > 12) {
      hour = (dateTime.hour - 12).toString();
    } else if (dateTime.hour == 0) {
      hour = "12";
    }

    return "$hour:$minute $period";
  }

  void bookAppointment(String patientDocID, int doctorId, DateTime selectedDate,
      String selectedTime, String complaint) async {
    EasyLoading.show(status: 'Booking Appointment...');

    List<String> timeParts = selectedTime.split(" ");
    List<String> hourMinute = timeParts[0].split(":");

    int hour = int.parse(hourMinute[0]);
    int minute = int.parse(hourMinute[1]);

    if (timeParts[1] == "pm" && hour != 12) {
      hour += 12;
    }

    if (timeParts[1] == "am" && hour == 12) {
      hour = 0;
    }

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
      complaint: complaint,
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
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Info Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: AssetImage(widget.doctor.image),
                    ),
                    const SizedBox(width: defaultPadding),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.doctor.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.medical_services,
                                color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              widget.doctor.sector,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: defaultPadding),
              Calendar(
                onDateSelected: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
              ),
              const SizedBox(height: defaultPadding),
              Text(
                "Available Slots",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: defaultPadding),
              FutureBuilder<List<String>>(
                future: fetchBookedSlots(widget.doctor.id),
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
                      childAspectRatio: 2.5,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
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
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isBooked
                                ? Colors.grey.shade300
                                : (selectedSlot == index
                                    ? primaryColor
                                    : Colors.white),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            isBooked ? 'Booked' : slots[index],
                            style: TextStyle(
                              color: isBooked
                                  ? Colors.white
                                  : (selectedSlot == index
                                      ? Colors.white
                                      : primaryColor),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: defaultPadding),
              Text(
                "Patient Message / Note",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: defaultPadding),
              TextField(
                controller: complaintController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Enter your message here...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    String patientDocID =
                        FirebaseAuth.instance.currentUser!.uid;
                    int doctorId = widget.doctor.id;

                    if (selectedDate != null) {
                      String selectedTime = slots[selectedSlot];
                      String complaint = complaintController.text;
                      bookAppointment(patientDocID, doctorId, selectedDate!,
                          selectedTime, complaint);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please select a date.")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: primaryColor,
                  ),
                  child: const Text("Confirm Appointment"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
