import 'package:flutter/material.dart';
import 'upper.dart';
import 'lower.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart'; // for darkModeNotifier
import 'ContactPost.dart'; // this contains addContactToFirebase()
import 'ContactDel.dart';
import 'ContactAdd.dart';
import 'Upper2.dart';

class TrustedContactsScreen extends StatefulWidget {
  const TrustedContactsScreen({super.key});

  @override
  State<TrustedContactsScreen> createState() => _TrustedContactsScreenState();
}

class _TrustedContactsScreenState extends State<TrustedContactsScreen> {
  final Color primaryColor = const Color(0xFF92392B);

  // Controllers for text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Relation Dropdown
  String selectedRelation = "Parent";
  final List<String> relationOptions = [
    "Parent",
    "Sibling",
    "Friend",
    "Spouse",
    "Colleagues",
    "Other"
  ];

  // List of contacts
  List<Map<String, String>> contacts = [];

  @override
  void initState() {
    super.initState();
    _loadSavedContacts();
  }

  Future<void> _loadSavedContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final names = prefs.getString("contact_names") ?? "";
    final phones = prefs.getString("contact_phones") ?? "";
    final relations = prefs.getString("contact_relations") ?? "";

    final nameList = names.isEmpty ? [] : names.split(',');
    final phoneList = phones.isEmpty ? [] : phones.split(',');
    final relationList = relations.isEmpty ? [] : relations.split(',');

    setState(() {
      contacts = List.generate(nameList.length, (index) {
        return {
          "name": nameList[index],
          "phone": phoneList.length > index ? phoneList[index] : "",
          "relation": relationList.length > index ? relationList[index] : "",
        };
      });
    });
  }

  /// ✅ Clean _addContact method
  Future<void> _addContact() async {
    await addContactToFirebase(
      context: context,
      nameController: nameController,
      phoneController: phoneController,
      selectedRelation: selectedRelation,
    );

    setState(() {
      _loadSavedContacts(); // refresh the displayed list after adding
      selectedRelation = "Parent";
    });
  }

  void _pickFromDeviceContacts() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Pick from device contacts")));
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

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
                const SizedBox(height: 70),




                /// Scrollable Section
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          "Trusted Contacts",
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Divider(thickness: 1.0, color: borderColor),
                        const SizedBox(height: 10),

                        // Name Field
                        _buildLabel("Name", textColor),
                        _buildTextField(nameController, "Enter Name", cardColor, textColor,
                            hintColor, borderColor),

                        // Phone Field
                        _buildLabel("Phone Number", textColor),
                        _buildTextField(
                            phoneController,
                            "Enter Phone Number",
                            cardColor,
                            textColor,
                            hintColor,
                            borderColor,
                            keyboardType: TextInputType.phone),

                        // Relation Dropdown
                        _buildLabel("Relation", textColor),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: borderColor),
                            color: cardColor,
                          ),
                          child: DropdownButton<String>(
                            value: selectedRelation,
                            isExpanded: true,
                            underline: const SizedBox(),
                            items: relationOptions
                                .map((rel) => DropdownMenuItem(
                              value: rel,
                              child: Text(rel, style: TextStyle(color: Colors.black)),
                            ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedRelation = value!;
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Add Button + Pick from device
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFA9271B), Colors.black87],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: ElevatedButton(
                                onPressed: _addContact,
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
                                  "Add Contact",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await pickContactFromDevice(
                                  context: context,
                                  nameController: nameController,
                                  phoneController: phoneController,
                                );
                              },
                              icon: const Icon(Icons.add, color: Colors.red),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        Divider(color: borderColor),
                        const SizedBox(height: 10),
                        Text(
                          "Saved Contacts",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: textColor),
                        ),
                        const SizedBox(height: 10),

                        // List of contacts
                        contacts.isEmpty
                            ? Center(
                            child: Text("No contacts added yet.",
                                style: TextStyle(color: textColor)))
                            : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: contacts.length,
                          itemBuilder: (context, index) {
                            final contact = contacts[index];
                            return Card(
                              color: cardColor,
                              elevation: 2,
                              margin:
                              const EdgeInsets.symmetric(vertical: 5),
                              child: ListTile(
                                leading:
                                Icon(Icons.person, color: textColor),
                                title: Text(contact["name"] ?? "",
                                    style: TextStyle(color: textColor)),
                                subtitle: Text(
                                  "${contact["relation"] ?? ""} | ${contact["phone"] ?? ""}",
                                  style: TextStyle(color: textColor),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () async {
                                    await deleteContactFromFirebase(context: context, index: index);
                                    setState(() {
                                      contacts.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
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

  // ---------- UI Helper Widgets ----------

  Widget _buildLabel(String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, top: 10),
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 14, color: textColor),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String hint,
      Color fillColor,
      Color textColor,
      Color hintColor,
      Color borderColor, {
        TextInputType keyboardType = TextInputType.text,
      }) {
    return SizedBox(
      height: 42,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 13, color: hintColor),
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
            borderSide: BorderSide(color: primaryColor, width: 1.2),
          ),
        ),
      ),
    );
  }
}
