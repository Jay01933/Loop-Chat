import 'dart:developer';
import 'package:chatapp/pages/loginandsignup/chattingscreen.dart';
import 'package:chatapp/pages/loginandsignup/signupscreen.dart';
import 'package:chatapp/theme/theme.dart';
import 'package:chatapp/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final bool result = false;
  bool _isSigning = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData currentTheme = Theme.of(context);

    return Theme(
      data:
          currentTheme.brightness == Brightness.light ? lightTheme : darkTheme,
      child: Scaffold(
        body: Container(
          color: currentTheme.brightness == Brightness.light
              ? lightTheme.scaffoldBackgroundColor
              : darkTheme.scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            borderRadius: BorderRadius.circular(25),
                            shadowColor: Colors.white70,
                            color: Colors.white,
                            elevation: 8,
                            child: TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(width: 2),
                                ),
                                fillColor: Colors.white,
                                labelText: 'Email',
                                hintText: 'Enter your email',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                prefixIcon:
                                    const Icon(Icons.alternate_email_sharp),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Material(
                            borderRadius: BorderRadius.circular(25),
                            shadowColor: Colors.white70,
                            color: Colors.white,
                            elevation: 8,
                            child: TextField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(width: 2),
                                ),
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                prefixIcon: const Icon(Icons.password_outlined),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                              ),
                              obscureText: true,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Login Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () => {
                                  if (_emailController.text.isNotEmpty &&
                                      _passwordController.text.isNotEmpty)
                                    {
                                      _login(),
                                    }
                                  else
                                    {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                                title: const Text('Error'),
                                                content: const Text(
                                                    'Please enter both email and password.'),
                                                actions: <Widget>[
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text('OK'))
                                                ]);
                                          })
                                    },
                                },
                                child: Text(
                                  'Login',
                                  style: GoogleFonts.robotoMono(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () async => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SignupScreen())),
                                },
                                child: Text(
                                  'Signup',
                                  style: GoogleFonts.robotoMono(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              //BottomNavigationBar(items: )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    setState(() {
      _isSigning = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    setState(() {
      _isSigning = false;
    });

    if (user != null) {
      log("User is successfully signed in");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Sign In Successful'),
            content: const Text('You have successfully signed in.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      log("Some error occurred");
    }
  }

  void _login() {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please enter both email and password.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      _auth.checkUserExists(email, password).then((exists) {
        if (exists) {
          _auth.signInWithEmailAndPassword(email, password).then((user) {
            if (user != null) {
              String userEmail = user.email!;
              String? userDisplayName = user.displayName;
              String? userUid = user.uid;

              log('User email: $userEmail');
              log('User UID : $userUid');
              if (userDisplayName != null) {
                log('User display name: $userDisplayName');
              } else {
                log('User display name: Not available');
              }

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChatScreenMain()));
            } else {
              log('Error: User is null');
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Error'),
                    content: const Text('Failed to sign in. Please try again.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          }).catchError((error) {
            log('Error signing in: $error');
          });
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('User Not Found'),
                content: const Text(
                    'User with this email is not signed up. Please sign up.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }).catchError((error) {
        log('Error checking user existence: $error');
      });
    }
  }
}
