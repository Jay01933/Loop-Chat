import 'package:chatapp/pages/loginandsignup/loginscreen.dart';
import 'package:chatapp/pages/spalshscreen.dart';
import 'package:chatapp/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainPageScreen extends StatefulWidget {
  const MainPageScreen({super.key});

  @override
  State<MainPageScreen> createState() => _MainPageScreenState();
}

class _MainPageScreenState extends State<MainPageScreen> {
  List<Color> bgcolors = [
    const Color.fromRGBO(39, 40, 41, 1),
    const Color.fromRGBO(97, 103, 122, 0.99),
    const Color.fromRGBO(34, 40, 49, 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black87,
                Colors.grey.shade900,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
            border: Border.all(color: Colors.black)),
        child: MainLogoScreen(),
      ),
    );
  }
}
