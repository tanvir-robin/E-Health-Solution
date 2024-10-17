import 'package:dental_care/models/AvailableDoctor.dart';
import 'package:dental_care/screens/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _fetchConversations() async {
    String patientId = FirebaseAuth.instance.currentUser!.uid;

    QuerySnapshot conversationSnapshot = await _firestore
        .collection('conversations')
        .where('participants', arrayContains: patientId)
        .get();

    List<Map<String, dynamic>> conversations = [];
    for (var doc in conversationSnapshot.docs) {
      String conversationId = doc.id;
      List<String> participants = List.from(doc['participants']);
      participants.remove(patientId); // Remove patient ID to get the doctor ID

      // Assuming there is only one doctor in a conversation
      String doctorId = participants.first;
      String lastMessage = await _fetchLastMessage(conversationId);

      conversations.add({
        'doctorId': doctorId,
        'conversationId': conversationId,
        'lastMessage': lastMessage,
      });
    }
    return conversations;
  }

  Future<String> _fetchLastMessage(String conversationId) async {
    QuerySnapshot messageSnapshot = await _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (messageSnapshot.docs.isNotEmpty) {
      return messageSnapshot.docs.first['message'];
    }
    return 'No messages yet';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversations'),
        backgroundColor: Colors.teal, // Custom color for the AppBar
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchConversations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No conversations available'));
          }

          List<Map<String, dynamic>> conversations = snapshot.data!;

          return ListView.separated(
            itemCount: conversations.length,
            separatorBuilder: (context, index) =>
                Divider(color: Colors.grey[300]),
            itemBuilder: (context, index) {
              var conversation = conversations[index];
              String doctorId = conversation['doctorId'];
              String conversationId = conversation['conversationId'];
              String lastMessage = conversation['lastMessage'];

              // Find the doctor's name based on doctorId
              AvailableDoctor? doctor = demoAvailableDoctors.firstWhere(
                (doc) => doc.id.toString() == doctorId,
                orElse: () => AvailableDoctor(
                  id: 0,
                  name: "Unknown Doctor",
                  sector: "",
                  experience: 0,
                  patients: "",
                  image: "",
                  email: "",
                  password: "",
                ),
              );

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        doctorId: doctor.id,
                        patientId: FirebaseAuth.instance.currentUser!.uid,
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.teal.shade300,
                          child: Text(
                            doctor.name.isNotEmpty ? doctor.name[0] : 'D',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doctor.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              SizedBox(height: 4),
                              Text(
                                lastMessage,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
