// Appointment model class with toJson and fromJson
import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String patientDocID, complaint;
  final int doctorId;
  final DateTime dateTime;
  final String status; // New field for appointment status

  Appointment({
    required this.patientDocID,
    required this.complaint,
    required this.doctorId,
    required this.dateTime,
    required this.status,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'createdAt': DateTime.now(),
      'complaint': complaint,
      'patientDocID': patientDocID,
      'doctorId': doctorId,
      'dateTime': dateTime,
      'status': status, // Include status in the JSON
    };
  }

  // Create from JSON
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      complaint: json['complaint'],
      patientDocID: json['patientDocID'],
      doctorId: json['doctorId'],
      dateTime: (json['dateTime'] as Timestamp).toDate(),
      status: json['status'], // Get status from JSON
    );
  }
}
