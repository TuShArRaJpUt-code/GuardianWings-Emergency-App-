import 'package:flutter/material.dart';
import 'package:guradian_angel/fetchDATA.dart';
import 'dart:async';
import 'package:guradian_angel/login.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'postDart.dart';
import 'package:firebase_database/firebase_database.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  bool _obscureText = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Start fade-in after a short delay
    Timer(const Duration(milliseconds: 500), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final TextEditingController username = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController re_passwordController = TextEditingController();
  var msg = ". . .";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 30),
              height: 300,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFA9271B), Colors.black],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    "$msg",
                    style: const TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Let's",
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  const Text(
                    "Create\nYour\nAccount",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),

                      SizedBox(
                        width: 300,
                        child: TextField(
                          controller: username,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Colors.grey,
                            ),
                            hintText: 'Full Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: 300,
                        child: TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: Colors.grey,
                            ),
                            hintText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: 300,
                        child: TextField(
                          obscureText: _obscureText,
                          controller: passwordController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText ? Icons.visibility : Icons
                                      .visibility_off,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                }
                            ),
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: Colors.grey,
                            ),
                            hintText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: 300,
                        child: TextField(
                          obscureText: _obscureText,
                          controller: re_passwordController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.grey,
                            ),
                            hintText: 'Retype Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFA9271B), Colors.black],
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            var email = emailController.text.toString();
                            var name = username.text.toString();
                            var pas = passwordController.text.toString();
                            var re_pas = re_passwordController.text.toString();

                            // Password validation regex
                            final passwordRegex =
                            RegExp(
                                r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

                            if (email != "" && name != "" && pas != "" &&
                                re_pas != "") {
                              // Check if passwords match
                              if (pas != re_pas) {
                                msg = "Passwords do not match";
                                setState(() {});
                                return;
                              }

                              // Check if password is strong
                              if (!passwordRegex.hasMatch(pas)) {
                                msg =
                                "Password: 8+ chars, upper, lower, number, symbol.";
                                setState(() {});
                                return;
                              }

                              // Check if user already exists
                              var data = await fetch(email, pas);
                              if (data.containsKey('found') &&
                                  data['found'] == true) {
                                msg = "User Already Exist";
                                setState(() {});
                              } else {
                                var user = PostData(
                                  username: name,
                                  email: email,
                                  password: pas,
                                );

                                // Send data and get boolean result
                                bool result = await user.sendData();

                                if (result) {
                                  msg = "User Registered. Go to Login Page";
                                } else {
                                  msg = "Registration failed. Try again!";
                                }

                                setState(() {}); // Update the UI with the message
                              }
                            } else {
                              msg = "Fill All Fields";
                              setState(() {});
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 100,
                            ),
                            shadowColor: Colors.black54,
                            elevation: 8,
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),


                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            "Have an Account?",
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {},
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()));
                              },
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Color(0xFFA9271B),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<Map<String, dynamic>> fetch(String email, String pass) async {
    try {
      final databaseRef = FirebaseDatabase.instance.ref("/users");
      final snapshot = await databaseRef.get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;

        for (var entry in data.entries) {
          final user = entry.value as Map<dynamic, dynamic>;

          // Check if email and password match
          if (user['email'] == email && user['password'] == pass) {
            final userData = {
              "id": entry.key,
              "username": user["username"],
              "email": user["email"],
              "password": user["password"],
              "address": user["address"],
              "phone": user["phone"],
              "found": true,
              // Add contact info here, make sure it exists
              "contact": user["Contact"] ?? {},
            };
            print("✅ User found:");
            return userData;
          }
        }
        return {"found": false};
      } else {
        print("No data available at /users node.");
        return {"message": "No user found"};
      }
    } catch (e) {
      print("Error fetching data: $e");
      return {"message": "Error fetching data: $e"};
    }
  }

}
