import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> deleteContactFromFirebase({
  required BuildContext context,
  required int index,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();

    // Get stored user info
    final userId = prefs.getString("id");
    if (userId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("User not found in preferences")));
      return;
    }

    // Fetch current contacts
    List<String> names = (prefs.getString("contact_names") ?? "").split(",").where((e) => e.isNotEmpty).toList();
    List<String> phones = (prefs.getString("contact_phones") ?? "").split(",").where((e) => e.isNotEmpty).toList();
    List<String> relations = (prefs.getString("contact_relations") ?? "").split(",").where((e) => e.isNotEmpty).toList();

    if (index < 0 || index >= names.length) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Invalid contact index")));
      return;
    }

    // Remove selected contact
    names.removeAt(index);
    if (index < phones.length) phones.removeAt(index);
    if (index < relations.length) relations.removeAt(index);

    // Save updated data locally
    await prefs.setString("contact_names", names.join(","));
    await prefs.setString("contact_phones", phones.join(","));
    await prefs.setString("contact_relations", relations.join(","));

    // Update in Firebase
    final userRef = FirebaseDatabase.instance.ref("/users/$userId/Contact");
    await userRef.update({
      "Name": names.join(","),
      "Pho": phones.join(","),
      "Relation": relations.join(","),
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Contact deleted successfully!")));
  } catch (e) {
    print("❌ Error deleting contact: $e");
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Error: $e")));
  }
}
