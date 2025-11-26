import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> updatePassword(String newPassword) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("id");

    if (userId == null || userId.isEmpty) {
      print("⚠️ No user ID found in SharedPreferences. Please log in again.");
      return;
    }

    final databaseRef = FirebaseDatabase.instance.ref("/users/$userId");

    // Update password in Firebase Realtime Database
    await databaseRef.update({"password": newPassword});
    print("✅ Password updated successfully in Firebase.");

    // Update local SharedPreferences
    await prefs.setString("password", newPassword);
    print("✅ Password updated locally in SharedPreferences.");

  } catch (e) {
    print("❌ Error updating password: $e");
  }
}
