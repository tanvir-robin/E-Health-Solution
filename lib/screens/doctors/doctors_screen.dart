import 'package:dental_care/components/custom_app_bar.dart';
import 'package:dental_care/constants.dart';
import 'package:dental_care/models/AvailableDoctor.dart';
import 'package:dental_care/screens/details/doctor_details_screen.dart';
import 'package:flutter/material.dart';

import 'components/docotor_card.dart';

class DoctorsScreen extends StatelessWidget {
  const DoctorsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              CustomAppBar(text: "Available", title: "Specialist"),
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: demoAvailableDoctors.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: defaultPadding,
                    mainAxisSpacing: defaultPadding,
                  ),
                  itemBuilder: (context, index) => DoctorCard(
                    doctor: demoAvailableDoctors[index],
                    press: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoctorDetailsScreen(
                          selectedDoctor: demoAvailableDoctors[index],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
