import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

class MainChatScreen extends StatefulWidget {
  final String receiverUserID;

  const MainChatScreen({Key? key, required this.receiverUserID})
      : super(key: key);

  @override
  State<MainChatScreen> createState() => _MainChatScreenState();
}

class _MainChatScreenState extends State<MainChatScreen> {
  TextEditingController messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final MessageService _messageService = MessageService();
  final DatabaseReference _user = FirebaseDatabase.instance.ref('Database');

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DatabaseEvent>(
          stream: _user.child(_auth.currentUser!.uid).onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
              var userData = snapshot.data!.snapshot.value;
              if (userData is Map<String, dynamic>) {
                // Added type check
                var userEmail = userData['user'] ?? 'Unknown Email';
                return Text(userEmail);
              } else {
                return Text('Chat app');
              }
            } else {
              return Text('Loading...');
            }
          },
        ),
        titleTextStyle: GoogleFonts.outfit(
          textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<DatabaseEvent>(
                stream: _messageService.getMessage(
                  _auth.currentUser!.uid,
                  widget.receiverUserID,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text('No messages yet.'));
                  }

                  DataSnapshot dataSnapshot = snapshot.data!.snapshot;
                  Map<dynamic, dynamic>? messages =
                      dataSnapshot.value as Map<dynamic, dynamic>?;

                  if (messages == null) {
                    return const Center(child: Text('No messages yet.'));
                  }

                  List<Widget> messageWidgets = [];
                  messages.forEach((key, value) {
                    final message = Map<String, dynamic>.from(value);
                    final currentUserID = _auth.currentUser!.uid;
                    log("Message: $message");

                    final messageWidget = Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 10),
                      child: ListTile(
                        title: Text(
                          message['message'] ?? 'No text',
                          textAlign: message['senderID'] == currentUserID
                              ? TextAlign.right
                              : TextAlign.left,
                          style: TextStyle(
                            color: message['senderID'] == currentUserID
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        /*
                        subtitle: Text(
                          message['timestamp'] ?? 'No timestamp',
                          style: TextStyle(
                            color: message['senderID'] == currentUserID
                                ? Colors.white70
                                : Colors.black54,
                          ),
                        ),
                        */
                        tileColor: message['senderID'] == currentUserID
                            ? Colors.blue
                            : Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(8.0),
                        visualDensity: VisualDensity(
                          horizontal:
                              message['senderID'] == currentUserID ? -4.0 : 4.0,
                        ),
                      ),
                    );
                    messageWidgets.insert(0, messageWidget);
                  });

                  return ListView(
                    reverse: true,
                    children: messageWidgets,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () async {
                      String message = messageController.text.trim();
                      if (message.isNotEmpty) {
                        await _sendMessage(message);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendMessage(String message) async {
    try {
      String currentUserID = _auth.currentUser!.uid;
      await _auth.currentUser!.reload();

      String? currentEmail = _auth.currentUser!.email;

      log("Current User: ${_auth.currentUser!.displayName.toString()}");

      String receiverID = widget.receiverUserID;
      await _messageService.sendMessage(
          currentUserID, receiverID, message, _auth);
      messageController.clear();
    } catch (e) {
      log("Error sending message: $e");
    }
  }
}

class MessageService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Stream<DatabaseEvent> getMessage(String userID, String receiverUserID) {
    List<String> ids = [userID, receiverUserID];
    ids.sort();
    String chatRoomID = ids.join('_');
    return _database
        .child('chat_room/$chatRoomID')
        .orderByChild('timestamp')
        .onValue;
  }

  Future<void> sendMessage(String currentUserID, String receiverID,
      String message, FirebaseAuth auth) async {
    String? currentEmail = auth.currentUser?.email;
    DateTime timestamp = DateTime.now();

    Map<String, dynamic> newMessage = {
      'senderID': currentUserID,
      'senderEmail': currentEmail,
      'receiverID': receiverID,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };

    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    await _database.child('chat_room/$chatRoomID').push().set(newMessage);
  }
}
