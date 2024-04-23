import 'package:chatapp/pages/loginandsignup/loginscreen.dart';
import 'package:chatapp/pages/loginandsignup/signupscreen.dart';
import 'package:chatapp/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainLogoScreen extends StatefulWidget {
  const MainLogoScreen({super.key});

  @override
  State<MainLogoScreen> createState() => _MainLogoScreenState();
}

class _MainLogoScreenState extends State<MainLogoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('res/LogoLoop.png'),
                  Text('LOOP CHAT',
                      style: GoogleFonts.bungeeShade(
                        textStyle: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold) 
                      )),
                  const SizedBox(height: 3),
                  const Text('Chat made easier',
                      style:
                          TextStyle(fontStyle: FontStyle.italic, fontSize: 17)),
                  const SizedBox(height: 60),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(
                              const Size(double.infinity, 50)),
                          backgroundColor:
                              customColor,
                              elevation: MaterialStateProperty.all(10),
                              shadowColor: MaterialStateColor.resolveWith((states) => Colors.black),

                          ),
                      child: Text('LOGIN',
                          style: GoogleFonts.robotoMono(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700)
                          ))),
                  const SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupScreen()));
                      },
                      style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(
                              const Size(double.infinity, 50)),
                          backgroundColor:
                              customColor,
                              elevation: MaterialStateProperty.all(10),
                              shadowColor: MaterialStateColor.resolveWith((states) => Colors.black),
                               // Set the minimum size of the button
                          ),
                      child: Text('SIGNUP',
                          style: GoogleFonts.robotoMono(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700)
                          ))),
                ],
              ))),
    );
  }
}