import 'package:dental_care/models/AvailableDoctor.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final int doctorId;
  final String patientId;

  const ChatScreen({
    Key? key,
    required this.doctorId,
    required this.patientId,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String doctorName = 'Dr.';

  void _setDoctorName() {
    AvailableDoctor? doctor = demoAvailableDoctors.firstWhere(
      (doctor) => doctor.id == widget.doctorId,
      orElse: () => AvailableDoctor(
        id: widget.doctorId,
        name: "Unknown Doctor",
        sector: "",
        experience: 0,
        patients: "",
        image: "",
        email: "",
        password: "",
      ),
    );
    setState(() {
      doctorName = doctor.name;
    });
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    String conversationId = await _getOrCreateConversation();

    await _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .add({
      'senderId': FirebaseAuth.instance.currentUser!.uid,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'senderName': FirebaseAuth.instance.currentUser!.displayName ?? 'Unknown',
    });

    _messageController.clear();
  }

  Future<String> _getOrCreateConversation() async {
    String patientId = widget.patientId;
    String doctorId = widget.doctorId.toString();

    QuerySnapshot conversationSnapshot = await _firestore
        .collection('conversations')
        .where('participants', arrayContains: patientId)
        .get();

    QueryDocumentSnapshot? conversation;
    for (var doc in conversationSnapshot.docs) {
      if ((doc['participants'] as List).contains(doctorId)) {
        conversation = doc;
        break;
      }
    }

    if (conversation != null) {
      return conversation.id;
    }

    DocumentReference newConversation =
        await _firestore.collection('conversations').add({
      'participants': [patientId, doctorId],
    });

    return newConversation.id;
  }

  @override
  void initState() {
    super.initState();
    _setDoctorName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with $doctorName'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('conversations')
                  .where('participants',
                      arrayContains: widget.patientId) // filter for patient
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                // Check if there's a conversation for this doctor-patient pair
                QueryDocumentSnapshot? conversationDoc;
                for (var doc in snapshot.data!.docs) {
                  if ((doc['participants'] as List)
                      .contains(widget.doctorId.toString())) {
                    conversationDoc = doc;
                    break;
                  }
                }

                if (conversationDoc == null) {
                  return Center(child: Text('No messages yet'));
                }

                // Stream messages for this specific conversation
                return StreamBuilder<QuerySnapshot>(
                  stream: conversationDoc.reference
                      .collection('messages')
                      .orderBy('timestamp',
                          descending: false) // Sort messages by timestamp
                      .snapshots(),
                  builder: (context, messageSnapshot) {
                    if (messageSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!messageSnapshot.hasData ||
                        messageSnapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No messages yet'));
                    }

                    var messages = messageSnapshot.data!.docs;

                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        var message =
                            messages[index].data() as Map<String, dynamic>?;

                        if (message == null ||
                            !message.containsKey('senderId')) {
                          return ListTile(
                            title: Text('Message with missing senderId'),
                          );
                        }

                        bool isMe = message['senderId'] ==
                            FirebaseAuth.instance.currentUser!.uid;

                        return ListTile(
                          title: Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color:
                                    isMe ? Colors.blue[100] : Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: isMe
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message['message'] ?? 'No message content',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    _formatTimestamp(message['timestamp']),
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: 'Type a message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(_messageController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _formatTimestamp(Timestamp? timestamp) {
  if (timestamp == null) return '';

  DateTime date = timestamp.toDate();
  return DateFormat.jm()
      .format(date); // Format the timestamp to show time (e.g., 4:03 PM)
}
