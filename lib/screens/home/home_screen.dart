import 'package:dental_care/screens/home/top_card.dart';
import 'package:flutter/material.dart';

import '../../components/custom_app_bar.dart';
import '../../constants.dart';
import 'components/available_doctors.dart';
import 'components/categories.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: primaryColor,
        elevation: 4,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              backgroundColor,
              Colors.white.withOpacity(0.9),
            ],
            stops: const [0.1, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppBar(
                  text: "Meet with your",
                  title: "Doctor",
                ),
                const SizedBox(height: 10),
                const HealthcareCard(
                  description: "Take health advantage",
                  gifUrl: "assets/images/health.gif",
                  title: "Smart Health",
                ),
                const SizedBox(height: 15),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Text(
                    "Find your healthcare solution",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: textColor.withOpacity(0.7),
                        ),
                  ),
                ),
                const SizedBox(height: 10),
                const Categories(),
                const SizedBox(height: 10),
                const AvailableDoctors()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
