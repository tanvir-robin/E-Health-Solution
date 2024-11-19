import 'package:dental_care/constants.dart';
import 'package:dental_care/screens/settings/settings_screen.dart';
import 'package:dental_care/screens/splash/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = '';
  String email = '';
  String phone = '';
  String createdAt = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      print(userDoc.data());
      if (userDoc.exists) {
        setState(() {
          username = userDoc['username'] ?? 'N/A';
          email = userDoc['email'] ?? 'N/A';
          phone = userDoc['phone'] ?? 'N/A';
          createdAt = DateFormat('dd MMMM yyyy')
              .format((userDoc['createdAt'] as Timestamp).toDate());
          isLoading = false;
        });
      } else {
        // Handle the case where the user document does not exist
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            ),
            icon: const Icon(
              Icons.settings,
              color: primaryColor,
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(
                        Radius.circular(defaultPadding / 2)),
                    child: Image.asset(
                      "assets/images/user_pic.png",
                      height: 120,
                      width: 120,
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: username,
                          decoration:
                              inputDecoration.copyWith(hintText: "Username"),
                          readOnly: true,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding),
                          child: TextFormField(
                            initialValue: email,
                            decoration:
                                inputDecoration.copyWith(hintText: "Email"),
                            readOnly: true,
                          ),
                        ),
                        TextFormField(
                          initialValue: phone,
                          decoration: inputDecoration.copyWith(
                              hintText: "Phone Number"),
                          readOnly: true,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding),
                          child: TextFormField(
                            initialValue: "Joined at: $createdAt",
                            decoration:
                                inputDecoration.copyWith(hintText: "Joined At"),
                            readOnly: true,
                          ),
                        ),
                        Center(
                          child: ElevatedButton(
                            child: const Text('Sign Out'),
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SplashScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

const InputDecoration inputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  border: OutlineInputBorder(borderSide: BorderSide.none),
  enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
  focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
);
