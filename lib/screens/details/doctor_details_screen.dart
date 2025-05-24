import 'package:dental_care/components/rating.dart';
import 'package:dental_care/constants.dart';
import 'package:dental_care/models/AvailableDoctor.dart';
import 'package:dental_care/screens/appointment/appointment_screen.dart';
import 'package:flutter/material.dart';

class DoctorDetailsScreen extends StatelessWidget {
  const DoctorDetailsScreen({super.key, required this.selectedDoctor});
  final AvailableDoctor selectedDoctor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedDoctor.name),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset(selectedDoctor.image)),
              const SizedBox(height: defaultPadding),
              // const Padding(
              //   padding: EdgeInsets.symmetric(vertical: defaultPadding),
              //   child: Communication(),
              // ),
              Text(
                selectedDoctor.sector,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(selectedDoctor.degrees),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: defaultPadding / 4),
                child: Rating(score: 5),
              ),
              const SizedBox(height: defaultPadding),
              Text(
                "About Doctor",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding / 2),
                child: Text(
                  "${selectedDoctor.name} is a highly skilled professional in the field of ${selectedDoctor.sector}. With over ${selectedDoctor.experience} years of experience, Dr. ${selectedDoctor.name} has successfully treated numerous patients. Known for a compassionate approach and dedication to patient care, Dr. ${selectedDoctor.name} is a trusted name in the medical community.",
                ),
              ),
              // const Padding(
              //   padding: EdgeInsets.symmetric(vertical: defaultPadding),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Highlight(
              //         name: "Patients",
              //         text: "1.08K",
              //       ),
              //       Highlight(
              //         name: "Experience",
              //         text: "8 Years",
              //       ),
              //       Highlight(
              //         name: "Reviews",
              //         text: "2.05K",
              //       ),
              //     ],
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppointmentScreen(
                        doctor: selectedDoctor,
                      ),
                    ),
                  ),
                  child: const Text("Book an Appoinment"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
