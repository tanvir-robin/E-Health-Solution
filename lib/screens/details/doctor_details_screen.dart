import 'package:dental_care/components/heightlight.dart';
import 'package:dental_care/components/rating.dart';
import 'package:dental_care/constants.dart';
import 'package:dental_care/models/AvailableDoctor.dart';
import 'package:dental_care/screens/appointment/appointment_screen.dart';
import 'package:flutter/material.dart';

import 'components/communication.dart';

class DoctorDetailsScreen extends StatelessWidget {
  const DoctorDetailsScreen({Key? key, required this.selectedDoctor})
      : super(key: key);
  final AvailableDoctor selectedDoctor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedDoctor.name!),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(selectedDoctor.image!),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: Communication(),
              ),
              Text(
                selectedDoctor.sector!,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text("Good Health Clinic, MBBS, FCPS"),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding / 4),
                child: Rating(score: 5),
              ),
              SizedBox(height: defaultPadding),
              Text(
                "About Doctor",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding / 2),
                child: Text(
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Highlight(
                      name: "Patients",
                      text: "1.08K",
                    ),
                    Highlight(
                      name: "Experience",
                      text: "8 Years",
                    ),
                    Highlight(
                      name: "Reviews",
                      text: "2.05K",
                    ),
                  ],
                ),
              ),
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
                  child: Text("Book an Appoinment"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
