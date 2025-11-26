import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'home.dart';
import 'dart:convert';

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  double _opacity = 0.0; // start invisible

  @override
  void initState() {
    super.initState();
    // Start the fade-in animation after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacity = 1.0; // fade to visible
      });
    });

    checkLogin();
  }

  void checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String email = prefs.getString('email') ?? "";
    String password = prefs.getString('password') ?? "";

    print("$email and $password");

    // Wait for 2 seconds (splash delay)
    Timer(Duration(seconds: 2), () {
      if (isLoggedIn && email != '' && password != '') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ),
        );
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFA9271B), Color(0xFF000000)],
        ),
      ),
      child: Center(
        child: AnimatedOpacity(
          opacity: _opacity, // use state variable
          duration: Duration(seconds: 1), // fade duration
          curve: Curves.easeIn,
          child: ClipOval(
            child: Image.asset(
              'assets/images/logo.jpeg',
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
