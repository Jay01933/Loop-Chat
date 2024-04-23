import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class MessageService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref("chat_room");
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String currentUserID, String receiverID, String message) async {
    try {
      final String? currentEmail = _auth.currentUser?.email;
      final DateTime timestamp = DateTime.now();

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

      await _database.child("chat_rooms").child(chatRoomID).push().set(newMessage);
    } catch (e) {
      log("Error sending message: $e");
      // Handle error
    }
  }

  Stream<DatabaseEvent> getMessage(String userID, String receiverUserID) {
    try {
      List<String> ids = [userID, receiverUserID];
      ids.sort();
      String chatRoomID = ids.join('_');
      return _database.child("chat_rooms").child(chatRoomID).orderByChild("timestamp").onValue;
    } catch (e) {
      log("Error getting message: $e");
      // Handle error
      return const Stream.empty();
    }
  }
}
