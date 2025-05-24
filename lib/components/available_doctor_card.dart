import 'dart:math';

import 'package:dental_care/models/AvailableDoctor.dart';
import 'package:flutter/material.dart';

import '../screens/details/doctor_details_screen.dart';

class AvailableDoctorCard extends StatelessWidget {
  const AvailableDoctorCard({
    super.key,
    required this.info,
  });

  final AvailableDoctor info;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DoctorDetailsScreen(
                  selectedDoctor: info,
                ),
              ));
        },
        child: _doctorTile(info));
  }

  Widget _doctorTile(AvailableDoctor model) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: Offset(2, 2),
              blurRadius: 10,
              color: Colors.grey.withOpacity(.1),
            ),
            BoxShadow(
              offset: Offset(-2, 0),
              blurRadius: 10,
              color: Colors.grey.withOpacity(.05),
            )
          ],
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: Hero(
              tag: 'doctor-${model.id}',
              child: Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 2,
                    ),
                  ],
                  image: DecorationImage(
                    image: AssetImage(model.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            title: Text(model.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(
                  model.sector,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF255ED6),
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text("4.8",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500)),
                    SizedBox(width: 12),
                    Icon(Icons.people, color: Colors.blue.shade700, size: 16),
                    SizedBox(width: 4),
                    Text("${model.patients} patients",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF255ED6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Book",
                style: TextStyle(
                  color: const Color(0xFF255ED6),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ));
  }

  Color randomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
}
