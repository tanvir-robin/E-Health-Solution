import 'package:dental_care/globals.dart';
import 'package:dental_care/models/AvailableDoctor.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DoctorChatScreen extends StatefulWidget {
  final String patientId;
  final String name;

  const DoctorChatScreen({
    super.key,
    required this.patientId,
    required this.name,
  });

  @override
  _DoctorChatScreenState createState() => _DoctorChatScreenState();
}

class _DoctorChatScreenState extends State<DoctorChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String doctorName = 'Dr.';

  void _setDoctorName() {
    // Use the loggedInDoctor global variable to get the doctor's name
    setState(() {
      doctorName =
          loggedInDoctor!.name; // Assuming loggedInDoctor has a 'name' property
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
      'senderId': loggedInDoctor!.id.toString(), // Using loggedInDoctor ID
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'senderName': loggedInDoctor!.name, // Using loggedInDoctor name
    });

    _messageController.clear();
  }

  Future<String> _getOrCreateConversation() async {
    String patientId = widget.patientId;
    String doctorId = loggedInDoctor!.id.toString(); // Using loggedInDoctor ID

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
        title: Text('Chat with ${widget.name}'),
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
                  return const Center(child: CircularProgressIndicator());
                }

                // Check if there's a conversation for this doctor-patient pair
                QueryDocumentSnapshot? conversationDoc;
                for (var doc in snapshot.data!.docs) {
                  if ((doc['participants'] as List)
                      .contains(loggedInDoctor!.id.toString())) {
                    conversationDoc = doc;
                    break;
                  }
                }

                if (conversationDoc == null) {
                  return const Center(child: Text('No messages yet'));
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
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!messageSnapshot.hasData ||
                        messageSnapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No messages yet'));
                    }

                    var messages = messageSnapshot.data!.docs;

                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        var message =
                            messages[index].data() as Map<String, dynamic>?;

                        if (message == null ||
                            !message.containsKey('senderId')) {
                          return const ListTile(
                            title: Text('Message with missing senderId'),
                          );
                        }

                        bool isMe = message['senderId'] ==
                            loggedInDoctor!.id
                                .toString(); // Match with loggedInDoctor

                        return ListTile(
                          title: Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.all(8),
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
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatTimestamp(message['timestamp']),
                                    style: const TextStyle(
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
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration:
                        const InputDecoration(hintText: 'Type a message'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
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
