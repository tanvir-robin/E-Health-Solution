import 'package:dental_care/models/AvailableDoctor.dart';
import 'package:dental_care/screens/details/doctor_details_screen.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../models/RecommendDoctor.dart';

class RecommendDoctorCard extends StatelessWidget {
  const RecommendDoctorCard({
    super.key,
    required this.doctor,
  });

  final RecommendedDoctor doctor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AvailableDoctor? availableDoctors;
        for (var element in demoAvailableDoctors) {
          if (element.name == doctor.name) {
            availableDoctors = (element);
            break;
          }
        }
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorDetailsScreen(
                selectedDoctor: availableDoctors!,
              ),
            ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
        padding: const EdgeInsets.all(defaultPadding),
        decoration: const BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(defaultPadding)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Looking For Your Desire Specialist Doctor?",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      Container(
                        margin:
                            const EdgeInsets.only(right: defaultPadding / 2),
                        width: 2,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Color(0xFF83D047),
                          borderRadius:
                              BorderRadius.all(Radius.circular(defaultPadding)),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctor.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            "${doctor.speciality}\n${doctor.institute}",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Image.asset(doctor.image),
            ),
          ],
        ),
      ),
    );
  }
}
