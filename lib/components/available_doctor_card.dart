import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dental_care/models/AvailableDoctor.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../screens/details/doctor_details_screen.dart';
import 'rating.dart';

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
              offset: Offset(4, 4),
              blurRadius: 10,
              color: Colors.grey.withOpacity(.2),
            ),
            BoxShadow(
              offset: Offset(-3, 0),
              blurRadius: 15,
              color: Colors.grey.withOpacity(.1),
            )
          ],
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(13)),
              child: Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: randomColor(),
                ),
                child: Image.asset(
                  model.image,
                  height: 50,
                  width: 50,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            title:
                Text(model.name, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              model.sector,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              size: 30,
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
