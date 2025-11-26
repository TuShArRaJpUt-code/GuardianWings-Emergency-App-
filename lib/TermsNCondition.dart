import 'package:flutter/material.dart';

class TermsFullScreenDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Dialog(
            insetPadding: EdgeInsets.zero, // Fullscreen
            backgroundColor: Colors.transparent,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFA9271B), Color(0xFF000000)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Header with Logo & Title
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(75),
                            child: Image.asset(
                              'assets/images/logo.jpeg',
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Welcome to our Guardian Angel!",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Scrollable Terms Content
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Your safety is our top priority. Before using our app, please read the following terms:",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 15),

                              // 1. Purpose of the App
                              Text(
                                "1. Purpose of the App",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "This app is designed to help users connect quickly with emergency services and trusted contacts in unsafe situations.",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 10),

                              // 2. Data Collection
                              Text(
                                "2. Data Collection",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "With your permission, we collect your:",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "• Location (real-time)\n• Emergency contact details\n• Chat history (only stored locally or anonymously)",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "We do not sell or misuse your data. It's used only to enhance your safety features.",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 10),

                              // 3. Location Sharing
                              Text(
                                "3. Location Sharing",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "You must enable GPS/location access for features like live tracking and nearby police alert to function properly.",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 10),

                              // 4. Emergency Services Disclaimer
                              Text(
                                "4. Emergency Services Disclaimer",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "While we strive to connect you with the nearest police station, we do not guarantee response times of third-party emergency services.",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 10),

                              // 5. Chatbot & Video Features
                              Text(
                                "5. Chatbot & Video Features",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "These tools are for additional support only and do not replace professional or legal assistance in emergencies.",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 10),

                              // 6. User Responsibility
                              Text(
                                "6. User Responsibility",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "• Do not misuse the emergency features.\n• Add only verified and trusted contacts.\n• Keep the app updated for full functionality.",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 10),

                              // 7. App Limitations
                              Text(
                                "7. App Limitations",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "This app cannot function without internet/GPS. It may not work properly in low-signal or restricted environments.",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 10),

                              // 8. Changes to Terms
                              Text(
                                "8. Changes to Terms",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "We may update these terms. You’ll be notified in-app when changes are made.",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 10),

                              // 9. Legal Action for Misuse
                              Text(
                                "9. Legal Action for Misuse",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "To ensure this platform remains safe and trustworthy:",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "• False Alarms / Prank SOS: Triggering fake emergency alerts will result in account suspension and may be reported to authorities.\n"
                                    "• Providing Wrong Information: Entering fake emergency contacts or impersonating others may lead to permanent ban and legal consequences.\n"
                                    "• Harassment & Abuse: Any misuse of chat, video, or reporting features for harassment will be strictly dealt with and may result in police involvement.",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 10),

                              // 10. Final Note
                              Text(
                                "10. Final Note",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "By using this app, you agree to the above terms. Stay safe, stay strong.",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // OK Button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                          backgroundColor: const Color(0xFFA9271B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          "OK",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
