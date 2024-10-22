import 'package:dental_care/models/AvailableDoctor.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    super.key,
    required this.doctor,
    required this.press,
  });

  final AvailableDoctor doctor;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: defaultPadding / 4),
                  Text(
                    doctor.sector,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  const Text(
                    "Experience",
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    "${doctor.experience} Years",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "Patients",
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    doctor.patients,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Image.asset(
                doctor.image,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
