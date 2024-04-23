import 'dart:developer';

import 'package:chatapp/pages/loginandsignup/chatscreen.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class ChatScreenMain extends StatefulWidget {
  const ChatScreenMain({super.key});

  @override
  State<ChatScreenMain> createState() => _chatScreenMainState();
}

class _chatScreenMainState extends State<ChatScreenMain> {
  final DatabaseReference _user =
      FirebaseDatabase.instance.ref('Database').child('user');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _currentRoute = '/';

  @override
  void initState() {
    super.initState();
    _currentRoute = '/'; // Assuming the initial route is '/'
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData currentTheme = Theme.of(context);
    return Theme(
      data:
          currentTheme.brightness == Brightness.light ? lightTheme : darkTheme,
      child: Scaffold(
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Chats'),
          titleTextStyle: GoogleFonts.outfit(
              textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2)),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Text(_auth.currentUser!.displayName ?? 'Unknown User'),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<DatabaseEvent>(
                stream: FirebaseDatabase.instance.ref('Database').onValue,
                builder: (BuildContext context,
                    AsyncSnapshot<DatabaseEvent> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  DataSnapshot dataSnapshot = snapshot.data!.snapshot;
                  if (!dataSnapshot.exists) {
                    return const Text('No data available');
                  }
                  Map<dynamic, dynamic> users =
                      dataSnapshot.value as Map<dynamic, dynamic>;
                  List<dynamic> userList = users.values.toList();
                  return ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      final userData = userList[index];
                      if (userData == null) {
                        return const SizedBox.shrink();
                      }
                      final userName = userData['user'] as String;
                      final currentUser = getCurrentUser();
                      if (userName != currentUser!.email) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Material(
                            elevation: 10,
                            shadowColor: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                            child: ListTile(
                              title: Row(
                                children: [
                                  const Icon(Icons.person), // Add icon here
                                  const SizedBox(
                                      width:
                                          10), // Add spacing between icon and text
                                  Text(userName),
                                ],
                              ),
                              onTap: () {
                                String receiverID = userData['userID'];

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MainChatScreen(
                                            receiverUserID: receiverID)));
                              },
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: _currentRoute == '/chat_screen' ? const MyBottomNavBar() : null
      ),
    );
  }
}
