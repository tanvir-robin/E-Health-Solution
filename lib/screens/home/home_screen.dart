import 'package:dental_care/screens/home/top_card.dart';
import 'package:flutter/material.dart';

import '../../components/custom_app_bar.dart';
import 'components/available_doctors.dart';
import 'components/categories.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(
                text: "Meet with your",
                title: "Doctor",
              ),
              HealthcareCard(
                description: "Take health advatafe",
                gifUrl: "assets/images/health.gif",
                title: "Smart Health",
              ),
              Categories(),
              AvailableDoctors()
            ],
          ),
        ),
      ),
    );
  }
}
