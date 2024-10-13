import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String username;
  String email;
  String phone;
  DateTime createdAt;

  UserModel({
    required this.username,
    required this.email,
    required this.phone,
    required this.createdAt,
  });

  factory UserModel.fromJSON(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'],
      email: map['email'],
      phone: map['phone'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'username': username,
      'email': email,
      'phone': phone,
      'createdAt': createdAt,
    };
  }
}
