import 'package:dental_care/components/available_doctor_card.dart';
import 'package:dental_care/components/section_title.dart';
import 'package:dental_care/models/AvailableDoctor.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class AvailableDoctors extends StatelessWidget {
  const AvailableDoctors({
    Key? key,
  }) : super(key: key);

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
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              demoAvailableDoctors.length,
              (index) => Padding(
                padding: const EdgeInsets.only(left: defaultPadding),
                child: AvailableDoctorCard(
                  info: demoAvailableDoctors[index],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
