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
            title: "Available Doctors",
            pressOnSeeAll: () {},
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white.withOpacity(0.9),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08),
                blurRadius: 10,
                spreadRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 8),
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
