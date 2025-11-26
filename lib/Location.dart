import 'package:geolocator/geolocator.dart';

Future<List<double>?> getCurrentCoordinates() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    print("❌ Location services are disabled.");
    return null;
  }

  // Check for permissions
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print("❌ Location permission denied.");
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    print("❌ Location permission permanently denied.");
    return null;
  }

  // Fetch and return position as a list
  try {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    print("✅ Current Location: ${position.latitude}, ${position.longitude}");
    return [position.latitude, position.longitude];
  } catch (e) {
    print("⚠️ Error getting location: $e");
    return null;
  }
}
