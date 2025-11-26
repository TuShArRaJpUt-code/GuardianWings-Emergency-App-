import 'package:flutter/material.dart';
import 'package:guradian_angel/Account.dart';
import 'package:guradian_angel/TermsNCondition.dart';
import 'package:guradian_angel/about.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Lower.dart';
import 'main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Upper2.dart';
import 'dart:ui';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> userData = {};
  bool darkMode = false;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    loadUserData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _opacity = 1.0);
    });
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userData = {
        "id": prefs.getString("id") ?? "",
        "username": prefs.getString("username") ?? "",
        "email": prefs.getString("email") ?? "",
        "password": prefs.getString("password") ?? "",
        "address": prefs.getString("address") ?? "",
        "phone": prefs.getString("phone") ?? "",
        "contact_names": prefs.getString("contact_names") ?? "",
        "contact_phones": prefs.getString("contact_phones") ?? "",
        "contact_relations": prefs.getString("contact_relations") ?? "",
        "isDark": prefs.getBool("isDark") ?? false,
      };
      darkMode = prefs.getBool("isDark") ?? false;
      print("🌗 Dark mode currently: $darkMode");
    });
  }

  //Mailing Contact Us
  void openContactUsDialog(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("username")?.trim() ?? "User";

    // Remove emojis for mail compatibility (optional, safer)
    final safeUsername = username.replaceAll(RegExp(r'[^\x00-\x7F]'), '');

    final Map<String, String> reasons = {
      "Report Emergency":
      "Dear Guardian Angel Support Team,\n\n"
          "My name is $safeUsername. I am currently experiencing an emergency situation that requires immediate attention. "
          "The details of the incident are as follows:\n\n"
          "[Please provide a detailed description of the emergency here]\n\n"
          "I would greatly appreciate prompt assistance and guidance on how to proceed safely. "
          "Please contact me at your earliest convenience.\n\n"
          "Thank you for your prompt attention to this urgent matter.\n\n"
          "Sincerely,\n$safeUsername",

      "Safety Concern":
      "Dear Guardian Angel Support Team,\n\n"
          "I, $safeUsername, would like to report a safety concern in my local area. "
          "The situation is as follows:\n\n"
          "[Provide detailed description of the safety concern, location, and any relevant information]\n\n"
          "I would appreciate your guidance on how to address this issue or any preventive measures I should take. "
          "Ensuring safety and well-being is of utmost importance, and I trust your expertise in this matter.\n\n"
          "Thank you for your attention.\n\n"
          "Sincerely,\n$safeUsername",

      "Request Assistance":
      "Dear Guardian Angel Support Team,\n\n"
          "My name is $safeUsername. I am seeking assistance or guidance regarding a personal safety issue I am currently facing. "
          "The details are as follows:\n\n"
          "[Explain the issue in detail, including location, nature of the concern, and any previous steps taken]\n\n"
          "I would be grateful for your advice and support on how to handle this situation safely and effectively. "
          "Your prompt response would be highly appreciated.\n\n"
          "Thank you for your support.\n\n"
          "Sincerely,\n$safeUsername",

      "Feedback":
      "Dear Guardian Angel Team,\n\n"
          "My name is $safeUsername. I would like to share my feedback regarding the Guardian Angel application. "
          "Overall, I find the application [provide your general impression: e.g., highly useful, intuitive, etc.]. "
          "However, I have some suggestions to further improve the experience:\n\n"
          "[List your suggestions, improvements, or comments in detail]\n\n"
          "I hope this feedback will help enhance the app’s functionality and user experience. "
          "Thank you for considering my input.\n\n"
          "Sincerely,\n$safeUsername",

      "Other...":
      "Dear Guardian Angel Support Team,\n\n"
          "My name is $safeUsername. I would like to communicate the following message:\n\n"
          "[Please write your detailed message or concern here]\n\n"
          "I appreciate your time and consideration in addressing this matter. "
          "Looking forward to your response and guidance.\n\n"
          "Thank you.\n\n"
          "Sincerely,\n$safeUsername",
    };


    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            backgroundColor: Colors.black.withOpacity(0.6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            title: const Center(
              child: Text(
                "📧 Select Reason to Contact",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: reasons.entries.map((entry) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white70, width: 1.2),
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white12,
                        backgroundImage: AssetImage('assets/images/logo.jpeg'),
                      ),
                      title: Text(
                        entry.key,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white70,
                        size: 20,
                      ),
                      onTap: () async {
                        Navigator.pop(context);

                        final String subject = Uri.encodeComponent(entry.key);
                        final String body = Uri.encodeComponent(entry.value);

                        // Gmail intent
                        final Uri gmailUri = Uri.parse(
                            'googlegmail://co?to=guardianangelwing7@gmail.com&subject=$subject&body=$body');

                        // Fallback mailto
                        final Uri mailtoUri = Uri.parse(
                            'mailto:guardianangelwing7@gmail.com?subject=$subject&body=$body');

                        try {
                          if (await canLaunchUrl(gmailUri)) {
                            await launchUrl(gmailUri, mode: LaunchMode.platformDefault);
                          } else if (await canLaunchUrl(mailtoUri)) {
                            await launchUrl(mailtoUri, mode: LaunchMode.platformDefault);
                          } else {
                            throw 'No mail client found';
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'No mail app found! Please install a mail client.',
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFFa9271b);
    final Color iconColor = const Color(0xFFa9271b);
    final Color textColor = Colors.black87;

    final screenHeight = MediaQuery.of(context).size.height;
    final upperHeight = screenHeight * 0.4;
    final lowerHeight = screenHeight * 0.07;

    // Define colors depending on darkMode toggle
    final Color sectionBgColor = darkMode ? const Color(0xFF212121) : Colors.white;
    final Color cardColor = darkMode ? const Color(0xFF2C2C2C) : Colors.grey.shade100;
    final Color sectionTextColor = darkMode ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: sectionBgColor, // keep overall background white
      body: SafeArea(
        child: userData.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeInOut,
          child: Column(
            children: [
              Upper2(),
              const SizedBox(height: 70),

              // 🟣 Middle section where dark mode applies
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  color: sectionBgColor,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profile',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Divider(color: Colors.grey[400], thickness: 1),
                        const SizedBox(height: 12),

                        /// Account Section
                        buildCardItem(
                          icon: Icons.person,
                          iconColor: iconColor,
                          text: 'Account',
                          cardColor: cardColor,
                          textColor: sectionTextColor,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Account()),
                            );
                          },
                        ),
                        const SizedBox(height: 10),

                        Text(
                          'Settings',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14.5,
                            color: sectionTextColor,
                          ),
                        ),
                        const SizedBox(height: 8),

                        buildCardItem(
                          icon: Icons.store_mall_directory,
                          iconColor: iconColor,
                          text: 'Products',
                          cardColor: cardColor,
                          textColor: sectionTextColor,
                          onTap: () async {
                            final Uri url = Uri.parse('https://guardianangel.onrender.com/products/${userData['id']}');
                            if (!await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication, // important!
                            )) {
                              throw 'Could not launch $url';
                            }
                          },
                        ),
                        buildCardItem(
                          icon: Icons.language,
                          iconColor: iconColor,
                          text: 'Language',
                          cardColor: cardColor,
                          textColor: sectionTextColor,
                          onTap: () {},
                        ),
                        buildCardItem(
                          icon: Icons.question_mark,
                          iconColor: iconColor,
                          text: 'About',
                          cardColor: cardColor,
                          textColor: sectionTextColor,
                          onTap: () {
                            AboutFullScreenDialog.show(context);
                          },
                        ),
                        buildCardItem(
                          icon: Icons.rule_folder,
                          iconColor: iconColor,
                          text: 'Terms & Conditions',
                          cardColor: cardColor,
                          textColor: sectionTextColor,
                          onTap: () {
                            TermsFullScreenDialog.show(context);
                          },
                        ),
                        buildCardItem(
                          icon: Icons.mail,
                          iconColor: iconColor,
                          text: 'Contact Us',
                          cardColor: cardColor,
                          textColor: sectionTextColor,
                          onTap: () async {
                            openContactUsDialog(context);
                          },

                        ),

                        // 🔘 Dark Mode Switch
                        Card(
                          color: cardColor,
                          elevation: 1.5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.dark_mode, color: iconColor, size: 22),
                            title: Text(
                              'Dark Mode',
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                                color: sectionTextColor,
                              ),
                            ),
                            trailing: Transform.scale(
                                scale: 0.8,
                                child:Switch(
                                  activeThumbColor: Color(0xFFa9271b),
                                  activeTrackColor: Colors.red.shade200,
                                  value: darkMode,
                                  onChanged: (value) async {
                                    setState(() => darkMode = value);
                                    final prefs = await SharedPreferences.getInstance();
                                    await prefs.setBool("isDark", value);
                                    darkModeNotifier.value = value; // 🔹 notify all listeners
                                  },
                                )

                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),

              // 🔻 Lower section (unchanged)
              SizedBox(
                height: lowerHeight,
                child: const Lower(selectedIndex: 4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCardItem({
    required IconData icon,
    required Color iconColor,
    required String text,
    required Color cardColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 400),
        child: Card(
          color: cardColor,
          elevation: 1.5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            leading: Icon(icon, color: iconColor, size: 20),
            title: Text(
              text,
              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500, color: textColor),
            ),
            trailing: Icon(Icons.arrow_forward_ios, size: 13, color: textColor.withOpacity(0.7)),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
