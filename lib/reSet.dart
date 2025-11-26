import 'package:flutter/material.dart';
import 'Upper2.dart';
import 'Lower.dart';
import 'main.dart'; // For darkModeNotifier
import 'ReSerPassword.dart';

class ReSet extends StatefulWidget {
  const ReSet({super.key});

  @override
  State<ReSet> createState() => _ReSetState();
}

class _ReSetState extends State<ReSet> {
  final Color primaryColor = const Color(0xFF92392B);

  // Controllers
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final upperHeight = screenHeight * 0.4;
    final lowerHeight = screenHeight * 0.06;

    return ValueListenableBuilder<bool>(
      valueListenable: darkModeNotifier,
      builder: (context, darkMode, _) {
        final bgColor = darkMode ? const Color(0xFF212121) : Colors.white;
        final cardColor = darkMode ? const Color(0xFF2C2C2C) : Colors.white;
        final textColor = darkMode ? Colors.white : Colors.black87;
        final hintColor = darkMode ? Colors.white54 : Colors.black45;
        final borderColor = darkMode ? Colors.white54 : Colors.black26;

        return Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            child: Column(
              children: [
                /// Upper Section
                Upper2(),
                const SizedBox(height: 120),


                /// Scrollable Section
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Title
                        Text(
                          "Reset Password",
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Divider(thickness: 1.0, color: borderColor),
                        const SizedBox(height: 10),

                        /// New Password
                        _buildLabel("New Password", textColor),
                        _buildPasswordField(
                          controller: newPasswordController,
                          hint: "Enter new password",
                          isVisible: isPasswordVisible,
                          onToggle: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          height: 42,
                          fillColor: cardColor,
                          borderColor: borderColor,
                          textColor: textColor,
                          hintColor: hintColor,
                        ),

                        /// Confirm Password
                        _buildLabel("Confirm Password", textColor),
                        _buildPasswordField(
                          controller: confirmPasswordController,
                          hint: "Confirm new password",
                          isVisible: isConfirmPasswordVisible,
                          onToggle: () {
                            setState(() {
                              isConfirmPasswordVisible = !isConfirmPasswordVisible;
                            });
                          },
                          height: 42,
                          fillColor: cardColor,
                          borderColor: borderColor,
                          textColor: textColor,
                          hintColor: hintColor,
                        ),

                        const SizedBox(height: 20),

                        /// Update Button
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
                                final newPass = newPasswordController.text.trim();
                                final confirmPass = confirmPasswordController.text.trim();

                                if (newPass.isEmpty || confirmPass.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Please fill all fields")),
                                  );
                                  return;
                                }

                                if (newPass != confirmPass) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Passwords do not match")),
                                  );
                                  return;
                                }

                                // Strong password validation
                                final passwordRegex =
                                RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');

                                if (!passwordRegex.hasMatch(newPass)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Password must be at least 8 characters and include uppercase, lowercase, number, and special character")),
                                  );
                                  return;
                                }

                                await updatePassword(newPass);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Password updated successfully")),
                                );
                              },


                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Text(
                                "Update Password",
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

                /// Lower Section
                SizedBox(height: lowerHeight, child: const Lower(selectedIndex: 4)),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Label Builder
  Widget _buildLabel(String text, Color textColor, {double fontSize = 16}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, top: 10),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: fontSize, color: textColor),
      ),
    );
  }

  /// Password Field Builder
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool isVisible,
    required VoidCallback onToggle,
    double height = 46,
    Color fillColor = Colors.white,
    Color borderColor = Colors.black26,
    Color textColor = Colors.black87,
    Color hintColor = Colors.black45,
  }) {
    return SizedBox(
      height: height,
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 13, color: hintColor),
          filled: true,
          fillColor: fillColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: primaryColor, width: 1.2),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
              size: 18,
            ),
            onPressed: onToggle,
          ),
        ),
      ),
    );
  }
}
