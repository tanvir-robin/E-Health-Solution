import 'package:flutter/material.dart';

import 'recommended_doctor_card.dart';
import '../../../models/RecommendDoctor.dart';

class RecommendedDoctors extends StatelessWidget {
  const RecommendedDoctors({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.5,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.85, initialPage: 3),
        itemCount: demo_recommended_doctor.length,
        itemBuilder: (context, index) => RecommendDoctorCard(
          doctor: demo_recommended_doctor[index],
        ),
      ),
    );
  }
}
