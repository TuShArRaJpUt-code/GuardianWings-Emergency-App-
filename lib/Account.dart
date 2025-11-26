import 'package:flutter/material.dart';
import 'package:guradian_angel/PersonalInfo.dart';
import 'package:guradian_angel/logout.dart';
import 'package:guradian_angel/trustContact.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Upper.dart';
import 'Lower.dart';
import 'reSet.dart';
import 'main.dart'; // contains darkModeNotifier
import "Upper2.dart";

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => AccountState();
}

class AccountState extends State<Account> {

  Map<String, dynamic>? data;
  double _opacity = 0.0;
  bool _isDark = false; // Track dark mode

  @override
  void initState() {
    super.initState();
    loadUserData();
    loadDarkModeStatus(); // Load dark mode preference
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _opacity = 1.0);
    });
  }

  // 🔹 Load dark mode from SharedPreferences
  Future<void> loadDarkModeStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDark = prefs.getBool("isDark") ?? false;
    });
  }

  // 🔹 Toggle dark mode and save preference
  Future<void> toggleDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDark = !_isDark;
      prefs.setBool("isDark", _isDark);
      print("🌗 Dark Mode is now: $_isDark");
    });
  }

  // 🔹 Load user data from SharedPreferences
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
      _opacity = 1.0; // Start fade-in
    });
  }




  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final upperHeight = screenHeight * 0.4;
    final lowerHeight = screenHeight * 0.07;

    // 🔹 Wrap entire body in ValueListenableBuilder to listen to dark mode changes
    return ValueListenableBuilder<bool>(
      valueListenable: darkModeNotifier,
      builder: (context, darkMode, child) {
        final primaryColor = Colors.red;//(0xFFa9271b)
        final bgColor = darkMode ? const Color(0xFF212121) : Colors.white;
        final cardColor = darkMode ? const Color(0xFF2C2C2C) : Colors.grey.shade100;
        final textColor = darkMode ? Colors.white : Colors.black87;

        return Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            child: AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeInOut,
              child: Column(
                children: [
                  Upper2(),
                  const SizedBox(height: 70),

                  /// 🔸 Scrollable Middle Section
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Account',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                              color: Color(0xFFa9271b),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Divider(color: Colors.grey[400], thickness: 1, height: 18),
                          const SizedBox(height: 16),

                          /// Profile Settings
                          sectionTitle('Profile Settings', textColor),
                          buildCardItem(
                            icon: Icons.person_outline,
                            text: 'Personal Information',
                            cardColor: cardColor,
                            textColor: textColor,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const PersonalInfo()),
                              );
                            },
                          ),

                          const SizedBox(height: 14),

                          /// Contacts
                          sectionTitle('Contacts', textColor),
                          buildCardItem(
                            icon: Icons.people_outline,
                            text: 'Trusted Contact',
                            cardColor: cardColor,
                            textColor: textColor,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const TrustedContactsScreen()),
                              );
                            },
                          ),

                          const SizedBox(height: 14),

                          /// Account Actions
                          sectionTitle('Account Actions', textColor),
                          buildCardItem(
                            icon: Icons.vpn_key_outlined,
                            text: 'Reset Password',
                            cardColor: cardColor,
                            textColor: textColor,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ReSet()),
                              );
                            },
                          ),
                          buildCardItem(
                            icon: Icons.logout,
                            text: 'Logout',
                            cardColor: cardColor,
                            textColor: textColor,
                            onTap: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              await prefs.clear(); // 🔹 This deletes ALL SharedPreferences keys
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const LogoutScreen()),
                                    (Route<dynamic> route) => false,
                              );
                            },
                          ),
                          buildCardItem(
                            icon: Icons.delete_outline,
                            text: 'Delete Account',
                            cardColor: cardColor,
                            textColor: primaryColor,
                            onTap: () async {
                              if (data == null || data!["id"] == "") {
                                print("User ID not found!");
                                return;
                              }
                              final Uri url = Uri.parse('https://guardianangel.onrender.com/Delete/${data!["id"]}');
                              if (!await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication, // opens in browser
                              )) {
                                throw 'Could not launch $url';
                              }
                            },
                          ),


                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),

                  /// 🔹 Lower Section
                  SizedBox(height: lowerHeight, child: const Lower(selectedIndex: 4)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 🔸 Section Title Widget
  Widget sectionTitle(String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14.5,
          color: textColor,
        ),
      ),
    );
  }

  /// 🔸 Reusable Card Item
  Widget buildCardItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required Color cardColor,
    required Color textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 1.5,
        color: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          leading: Icon(icon, color: textColor, size: 20),
          title: Text(
            text,
            style: TextStyle(
              fontSize: 14.5,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 13, color: textColor.withOpacity(0.7)),
          onTap: onTap,
        ),
      ),
    );
  }
}
