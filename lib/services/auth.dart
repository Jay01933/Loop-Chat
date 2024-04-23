import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  get currentUser => null;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        log('The email address is already in use.');
      } else {
        log('An error occurred: ${e.code}');
      }
    }
    return null;
  }


Future<bool> checkUserExists(String email, String password) async {
  try {
    // Query the "Database" node for users with the given email
   DatabaseEvent snapshot = await FirebaseDatabase.instance
        .ref()
        .child('Database')
        .orderByChild('user')
        .equalTo(email)
        .once();

    if (snapshot.snapshot.exists) {
      // Iterate through the users
      Map<dynamic, dynamic>? users = snapshot.snapshot.value as Map<dynamic, dynamic>?;
      if (users != null) {
        for (var userKey in users.keys) {
          var user = users[userKey];
          // Check if the password matches
          if (user['password'] == password) {
            // Password matches, user exists
            return true;
          }
        }
      }
    }
    return false;
  } catch (error) {
    print('Error checking user existence: $error');
    return false;
  }
}


  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        log('Invalid email or password.');
      } else {
        log('An error occurred: ${e.code}');
      }
    }
    return null;
  }
void sendMessage(String senderId, String receiverId, String content) {
  DatabaseReference messagesRef = FirebaseDatabase.instance
      .ref()
      .child('users')
      .child(receiverId)
      .child('messages')
      .push();
  
  messagesRef.set({
    'sender': senderId,
    'receiver': receiverId,
    'timestamp': DateTime.now().millisecondsSinceEpoch,
    'content': content,
  });
}



}


