import 'package:chatapp/firebase_options.dart';
import 'package:chatapp/pages/loginandsignup/chattingscreen.dart';
import 'package:chatapp/pages/mainscreen.dart';
import 'package:chatapp/services/notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'My App', // App title
    initialRoute: '/',
    routes: {
      '/': (context) => const MainPageScreen(),
      '/chat_screen': (context) => const ChatScreenMain(),
    },
  ));
}
