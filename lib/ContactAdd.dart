import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

Future<void> pickContactFromDevice({
  required BuildContext context,
  required TextEditingController nameController,
  required TextEditingController phoneController,
}) async {
  try {
    // 🔹 Check and request permission properly
    bool permissionGranted = await FlutterContacts.requestPermission(readonly: true);

    if (!permissionGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Contact permission denied")),
      );
      return;
    }

    // 🔹 Fetch all contacts (to trigger permission on some devices)
    final contacts = await FlutterContacts.getContacts(withProperties: true);

    if (contacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No contacts found on device")),
      );
      return;
    }

    // 🔹 Pick contact using FlutterContacts built-in picker
    final contact = await FlutterContacts.openExternalPick();

    if (contact == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No contact selected")),
      );
      return;
    }

    // 🔹 Get complete contact details
    final fullContact = await FlutterContacts.getContact(contact.id);

    if (fullContact != null && fullContact.phones.isNotEmpty) {
      nameController.text = fullContact.displayName;
      phoneController.text = fullContact.phones.first.number;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selected: ${fullContact.displayName}")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selected contact has no phone number")),
      );
    }
  } catch (e) {
    print("❌ Error accessing contacts: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error accessing contacts: $e")),
    );
  }
}
