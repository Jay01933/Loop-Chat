import 'package:chatapp/pages/loginandsignup/loginscreen.dart';
import 'package:chatapp/pages/loginandsignup/signupscreen.dart';
import 'package:chatapp/pages/spalshscreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomGradientContainer extends StatelessWidget {
  final Widget child;
  final List<Color> gradientColors;
  final Alignment begin;
  final Alignment end;
  final List<double> stops;
  final BorderSide border;

  static const Color defaultGrey =
      Color(0xFF212121); // Equivalent to Colors.grey.shade900

  const CustomGradientContainer({
    super.key,
    required this.child,
    this.gradientColors = const [Colors.black87, defaultGrey],
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.stops = const [0.0, 1.0],
    this.border = const BorderSide(color: Colors.black),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: begin,
          end: end,
          stops: stops,
          tileMode: TileMode.clamp,
        ),
        border: Border.all(color: border.color, width: border.width),
      ),
      child: child,
    );
  }
}

class MyBottomNavBar extends StatefulWidget {
  const MyBottomNavBar({super.key});

  @override
  State<MyBottomNavBar> createState() => _MyButtomNavBarState();
}

class _MyButtomNavBarState extends State<MyBottomNavBar> {
  int myCurrentIndex = 0;
  List pages = const [
    MainLogoScreen(),
    SignupScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 25,
              offset: const Offset(8, 20))
        ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
              // backgroundColor: Colors.transparent,
              selectedItemColor: Colors.redAccent,
              unselectedItemColor: Colors.black,
              currentIndex: myCurrentIndex,
              onTap: (index) {
                setState(() {
                  myCurrentIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.login), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite), label: "Favorite"),
                //BottomNavigationBarItem(
                //  icon: Icon(Icons.settings), label: "Setting"),
                //BottomNavigationBarItem(
                //  icon: Icon(Icons.person_outline), label: "Profile"),
              ]),
        ),
      ),
      body: pages[myCurrentIndex],
    );
  }
}

MaterialStateColor customColor =
    MaterialStateColor.resolveWith((Set<MaterialState> states) {
  return const Color(0xFFF931AF);
});

ThemeData lightTheme = ThemeData(
  primaryColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFFF931AF), disabledColor: Colors.grey),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
        backgroundColor:
            MaterialStateColor.resolveWith((states) => const Color(0xFFF931AF)),
        elevation: const MaterialStatePropertyAll(10),
        enableFeedback: true,
        textStyle: MaterialStateTextStyle.resolveWith((states) =>
            GoogleFonts.robotoMono(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700)),
        shadowColor: MaterialStateColor.resolveWith((states) => Colors.black)),
  ),
  textTheme: TextTheme(
      labelLarge: GoogleFonts.robotoMono(
          color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
  brightness: Brightness.light,
  hintColor: Colors.black,
  iconTheme: const IconThemeData(
    color: Colors.black,
  ),
);

ThemeData darkTheme = ThemeData(
  primaryColor: Colors.black,
  scaffoldBackgroundColor: Colors.black,
  buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF008DDA), disabledColor: Colors.grey),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith(
              (states) => const Color(0xFF008DDA)),
          elevation: const MaterialStatePropertyAll(10),
          enableFeedback: true,
          textStyle: MaterialStateTextStyle.resolveWith(
              (states) => TextStyle(color: Colors.white)),
          shadowColor:
              MaterialStateColor.resolveWith((states) => Colors.black))),
  brightness: Brightness.dark,
  hintColor: Colors.white,
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
);
