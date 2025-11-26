import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

Future<void> addContactToFirebase({
  required BuildContext context,
  required TextEditingController nameController,
  required TextEditingController phoneController,
  required String selectedRelation,
}) async {
  try {
    if (nameController.text.isEmpty || phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill name and phone")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("id");

    if (userId == null || userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User ID not found. Please log in again.")),
      );
      return;
    }

    // 🔹 Read existing contacts
    final existingNames = prefs.getString("contact_names") ?? "";
    final existingPhones = prefs.getString("contact_phones") ?? "";
    final existingRelations = prefs.getString("contact_relations") ?? "";

    // 🔹 Append the new contact
    final updatedNames =
    existingNames.isEmpty ? nameController.text : "$existingNames,${nameController.text}";
    final updatedPhones =
    existingPhones.isEmpty ? phoneController.text : "$existingPhones,${phoneController.text}";
    final updatedRelations =
    existingRelations.isEmpty ? selectedRelation : "$existingRelations,$selectedRelation";

    // 🔹 Save locally
    await prefs.setString("contact_names", updatedNames);
    await prefs.setString("contact_phones", updatedPhones);
    await prefs.setString("contact_relations", updatedRelations);

    // 🔹 Update Firebase Database
    final dbRef = FirebaseDatabase.instance.ref("users/$userId/Contact");
    await dbRef.set({
      "Name": updatedNames,
      "Pho": updatedPhones,
      "Relation": updatedRelations,
    });

    // 🔹 UI feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Contact added successfully")),
    );

    // 🔹 Clear fields
    nameController.clear();
    phoneController.clear();

    print("✅ Contact added to Firebase and saved locally");
  } catch (e) {
    print("❌ Error adding contact: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error adding contact: $e")),
    );
  }
}
