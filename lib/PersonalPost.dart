import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Update user's personal information: username, phone, address
Future<void> updatePersonalInfo({
  required String username,
  required String phone,
  required String address,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("id");

    if (userId == null || userId.isEmpty) {
      print("⚠️ No user ID found. Please log in again.");
      return;
    }

    final databaseRef = FirebaseDatabase.instance.ref("/users/$userId");

    // Update Firebase
    await databaseRef.update({
      "username": username,
      "phone": phone,
      "address": address,
    });
    print("✅ Personal information updated successfully in Firebase.");

    // Update locally in SharedPreferences
    await prefs.setString("username", username);
    await prefs.setString("phone", phone);
    await prefs.setString("address", address);
    print("✅ Personal information updated locally in SharedPreferences.");
  } catch (e) {
    print("❌ Error updating personal information: $e");
  }
}
