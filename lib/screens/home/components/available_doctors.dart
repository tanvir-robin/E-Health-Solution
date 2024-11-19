import 'package:dental_care/components/available_doctor_card.dart';
import 'package:dental_care/components/section_title.dart';
import 'package:dental_care/models/AvailableDoctor.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class AvailableDoctors extends StatelessWidget {
  const AvailableDoctors({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: SectionTitle(
            title: "Available Doctor",
            pressOnSeeAll: () {},
          ),
        ),
        SingleChildScrollView(
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final AvailableDoctor doctor = demoAvailableDoctors[index];
              return AvailableDoctorCard(info: doctor);
            },
            itemCount: demoAvailableDoctors.length,
          ),
        ),
      ],
    );
  }
}
