// Portal.dart
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Location.dart';

class Portal {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref("/users");
  bool _isPosting = false;

  /// Start posting location & update status in Firebase
  Future<void> startSOS() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString("id");

    if (userId == null) {
      print("⚠️ User ID not found in SharedPreferences.");
      return;
    }

    _isPosting = true;

    // Continuously update location while SOS is active
    while (_isPosting) {
      final coordinates = await getCurrentCoordinates();
      if (coordinates != null) {
        await _databaseRef.child(userId).update({
          "liveTracking/latitude": coordinates[0],
          "liveTracking/longitude": coordinates[1],
          "liveTracking/status": true,
        });
        print("✅ SOS active. Location updated: ${coordinates[0]}, ${coordinates[1]}");
      }

      // wait 5 seconds before next update
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  /// Stop SOS and update status=false
  Future<void> stopSOS() async {
    _isPosting = false;
    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString("id");

    if (userId == null) return;

    await _databaseRef.child(userId).update({
      "liveTracking/status": false,
    });

    print("⚠️ SOS stopped. Status set to false.");
  }
}
