import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Blue_Tooth.dart';
import 'upper.dart';
import 'lower.dart';
import 'call.dart';
import 'HomeFun.dart';
import 'record.dart';
import 'Portal.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  Map<String, dynamic>? data;
  double _opacity = 0.0;
  bool _isDark = false;
  bool _showSOS = false; // 👈 Stored in SharedPreferences
  final AudioRecorderService _audioRecorder = AudioRecorderService();
  Portal portal = Portal();


  @override
  void initState() {
    super.initState();
    loadUserData();
    loadDarkModeStatus();
    loadShowSOSStatus(); // 👈 Load SOS button state
    listenToESP32();
  }

  void listenToESP32() {
    bluetoothService.messages.listen((message) {
      String cleanMsg = message.trim();

      print("Received: $cleanMsg");

      if (cleanMsg == "Button Pressed!") {
        triggerSOS();
      }

      if (cleanMsg == "SAFE") {
        stopSOS();
      }
    });
  }

  // 🔹 Load dark mode
  Future<void> loadDarkModeStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDark = prefs.getBool("isDark") ?? false;
    });
  }

  // 🔹 Toggle dark mode
  Future<void> toggleDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDark = !_isDark ;
      prefs.setBool("isDark", _isDark);
    });
  }

  // 🔹 Load user data
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = {
      "id": prefs.getString("id") ?? "",
      "username": prefs.getString("username") ?? "",
      "email": prefs.getString("email") ?? "",
      "password": prefs.getString("password") ?? "",
      "address": prefs.getString("address") ?? "",
      "phone": prefs.getString("phone") ?? "",
      "found": prefs.getBool("found") ?? false,
      "contact_names": prefs.getString("contact_names") ?? "",
      "contact_phones": prefs.getString("contact_phones") ?? "",
      "contact_relations": prefs.getString("contact_relations") ?? "",
    };

    setState(() {
      data = userData;
      _opacity = 1.0;
    });
  }

  // 🔹 Load _showSOS state from SharedPreferences
  Future<void> loadShowSOSStatus() async {
    final prefs = await SharedPreferences.getInstance();
    // Only override if the value exists in SharedPreferences
    if (prefs.containsKey("showSOS")) {
      setState(() {
        _showSOS = prefs.getBool("showSOS")!;
      });
    } else {
      _showSOS = true; // default: show SOS image
    }
  }




  // 🔹 Save _showSOS state
  Future<void> saveShowSOSStatus(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("showSOS", value);
  }

  Future<void> triggerSOS() async {
    await _audioRecorder.startRecording();
    await sendWhatsappFallback();
    await openDialPad('112');

    setState(() {
      _showSOS = true;
    });

    await saveShowSOSStatus(true);
    portal.startSOS();
  }

  Future<void> stopSOS() async {
    await _audioRecorder.stopRecording();

    setState(() {
      _showSOS = false;
    });

    await saveShowSOSStatus(false);
    await portal.stopSOS();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final upperHeight = screenHeight * 0.4;
    final lowerHeight = screenHeight * 0.07;

    return Scaffold(
      backgroundColor: _isDark ? const Color(0xFF2C2C2C) : Colors.white,
      body: SafeArea(
        child: data == null
            ? const Center(child: CircularProgressIndicator())
            : AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
          child: Column(
            children: [
              // 🔹 Upper Section
              SizedBox(height: upperHeight, child: Upper()),

              // 🔹 Middle Section
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Emergency Help Needed?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: _isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Press the button below and help will reach shortly",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _isDark
                              ? Colors.white54
                              : Colors.black38,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // ⚡ SOS / SAFE BUTTON AREA
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 600),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: _showSOS
                        // ✅ Show SOS IMAGE by default
                            ? Container(
                          key: const ValueKey('safeButton'),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFA9271B),
                                Colors.black,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ElevatedButton(
                            onPressed: stopSOS,
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
                              'Are You Safe?',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                            : InkWell(
                          key: const ValueKey('sosImage'),
                          onTap: triggerSOS,
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.shade200,
                                  blurRadius: 10,
                                  spreadRadius: 0,
                                ),
                              ],
                              image: const DecorationImage(
                                image: AssetImage(
                                  "assets/images/center_call.png",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),


                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              // 🔻 Lower Section
              SizedBox(height: lowerHeight, child: Lower()),
            ],
          ),
        ),
      ),
    );
  }
}
