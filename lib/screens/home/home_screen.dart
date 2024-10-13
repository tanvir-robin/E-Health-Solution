import 'package:flutter/material.dart';

import '../../components/custom_app_bar.dart';
import 'components/available_doctors.dart';
import 'components/categories.dart';
import 'components/recommended_doctors.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(
                text: "Find Your",
                title: "Specialist",
              ),
              RecommendedDoctors(),
              Categories(),
              AvailableDoctors()
            ],
          ),
        ),
      ),
    );
  }
}
