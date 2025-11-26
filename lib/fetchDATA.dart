import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

Future<void> fetchData(String email, String pass) async {
  try {
    final databaseRef = FirebaseDatabase.instance.ref("/users");
    final snapshot = await databaseRef.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;

      for (var entry in data.entries) {
        final user = entry.value as Map<dynamic, dynamic>;

        // ✅ Match email & password
        if (user['email'] == email && user['password'] == pass) {
          final prefs = await SharedPreferences.getInstance();

          // 🔹 Save basic user info separately
          await prefs.setString("id", entry.key.toString());
          await prefs.setString("username", user["username"] ?? "");
          await prefs.setString("email", user["email"] ?? "");
          await prefs.setString("password", user["password"] ?? "");
          await prefs.setString("address", user["address"] ?? "");
          await prefs.setString("phone", user["phone"] ?? "");
          await prefs.setBool("found", true);
          await prefs.setBool("isDark", false);
          darkModeNotifier.value = false;
          await prefs.setBool("showSOS", false);

          // 🔹 Handle contact list (if exists)
          // 🔹 Handle contact list (if exists)
          if (user["Contact"] != null) {
            final contact = user["Contact"];
            print(contact["Name"]);
            List<String> names = [];
            List<String> phones = [];
            List<String> relations = [];

            if (contact is List) {
              // Case 1: Firebase stores Contact as a list of maps
              for (var c in contact) {
                names.add(c["Name"] ?? "");
                phones.add(c["Phone"] ?? "");
                relations.add(c["Relation"] ?? "");
              }
            } else if (contact is Map) {
              // Case 2: Firebase stores Contact as a single map with comma-separated values
              final nameStr = contact["Name"] ?? "";
              final phoneStr = contact["Pho"] ?? contact["Phone"] ?? "";
              final relationStr = contact["Relation"] ?? "";

              names = nameStr.split(",");
              phones = phoneStr.split(",");
              relations = relationStr.split(",");
            }

            await prefs.setString("contact_names", names.join(","));
            await prefs.setString("contact_phones", phones.join(","));
            await prefs.setString("contact_relations", relations.join(","));

            print("✅ Contacts saved: $names | $phones | $relations");
          } else {
            await prefs.setString("contact_names", "");
            await prefs.setString("contact_phones", "");
            await prefs.setString("contact_relations", "");
          }




          print("✅ User found and saved locally!");
          return;
        }
      }

      // If not found
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("found", false);
      print("⚠️ No matching user found.");
    } else {
      print("🚫 No data available at /users node.");
    }
  } catch (e) {
    print("❌ Error fetching data: $e");
  }
}
