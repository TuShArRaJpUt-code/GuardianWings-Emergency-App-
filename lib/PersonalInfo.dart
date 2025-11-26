import 'package:flutter/material.dart';
import 'Lower.dart';
import 'main.dart'; // for darkModeNotifier
import 'PersonalPost.dart';
import 'Upper2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  // Declare controllers (without initial text)
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

// Function to fetch data from SharedPreferences and set controllers
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    // Fetch data (set default empty string if not found)
    final username = prefs.getString("username") ?? "";
    final email = prefs.getString("email") ?? "";
    final phone = prefs.getString("phone") ?? "";
    final address = prefs.getString("address") ?? "";

    // Assign to controllers
    usernameController.text = username;
    emailController.text = email;
    phoneController.text = phone;
    addressController.text = address;
  }

// Example usage inside initState (if in a StatefulWidget)
  @override
  void initState() {
    super.initState();
    loadUserData();
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final upperHeight = screenHeight * 0.4;
    final lowerHeight = screenHeight * 0.06;

    return ValueListenableBuilder<bool>(
      valueListenable: darkModeNotifier,
      builder: (context, darkMode, _) {
        final Color primaryColor = const Color(0xFFa9271b);
        final Color bgColor = darkMode ? const Color(0xFF212121) : Colors.white;
        final Color cardColor = darkMode ? const Color(0xFF2C2C2C) : Colors.white;
        final Color textColor = darkMode ? Colors.white : Colors.black87;
        final Color borderColor = darkMode ? Colors.white54 : Colors.black26;

        return Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            child: Column(
              children: [
                /// 🔹 Upper Section
                Upper2(),
                const SizedBox(height: 50),


                /// 🔸 Scrollable Section
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Title
                        Text(
                          "Personal Information",
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Divider(thickness: 1.0, color: borderColor),
                        const SizedBox(height: 10),

                        /// Username
                        _buildLabel("Username", textColor: textColor),
                        _buildTextField(
                          controller: usernameController,
                          textColor: textColor,
                          fillColor: cardColor,
                          borderColor: borderColor,
                        ),

                        /// Email
                        _buildLabel("Email (cannot be changed)",
                            textColor: textColor),
                        _buildTextField(
                          controller: emailController,
                          textColor: textColor,
                          fillColor: darkMode ? Colors.grey[800]! : Colors.grey[200]!,
                          readOnly: true,
                          borderColor: borderColor,
                        ),

                        /// Phone
                        _buildLabel("Phone", textColor: textColor),
                        _buildTextField(
                          controller: phoneController,
                          textColor: textColor,
                          fillColor: cardColor,
                          keyboardType: TextInputType.phone,
                          borderColor: borderColor,
                        ),

                        /// Address
                        _buildLabel("Address", textColor: textColor),
                        _buildTextField(
                          controller: addressController,
                          textColor: textColor,
                          fillColor: cardColor,
                          borderColor: borderColor,
                        ),

                        const SizedBox(height: 20),

                        /// Save Changes Button
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFA9271B), Colors.black87],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                final username = usernameController.text.trim();
                                final phone = phoneController.text.trim();
                                final address = addressController.text.trim();

                                if (username.isEmpty || phone.isEmpty || address.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Please fill all fields")),
                                  );
                                  return;
                                }

                                await updatePersonalInfo(
                                  username: username,
                                  phone: phone,
                                  address: address,
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Personal information updated successfully")),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Text(
                                "Save Changes",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                /// 🔹 Lower Section
                SizedBox(height: lowerHeight, child: const Lower(selectedIndex: 4)),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Label builder
  Widget _buildLabel(String text, {Color? textColor, double fontSize = 16}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, top: 10),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: fontSize,
          color: textColor ?? Colors.black87,
        ),
      ),
    );
  }

  /// TextField builder
  Widget _buildTextField({
    required TextEditingController controller,
    bool readOnly = false,
    Color fillColor = Colors.white,
    Color textColor = Colors.black87,
    Color borderColor = Colors.black26,
    TextInputType keyboardType = TextInputType.text,
    double height = 46,
  }) {
    return SizedBox(
      height: height,
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          filled: true,
          fillColor: fillColor,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: textColor, width: 1.2),
          ),
        ),
      ),
    );
  }
}
