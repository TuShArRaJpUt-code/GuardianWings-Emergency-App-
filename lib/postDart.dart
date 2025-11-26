// postDATA.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class PostData {
  final String username;
  final String email;
  final String password;

  // Constructor
  PostData({
    required this.username,
    required this.email,
    required this.password,
  });

  // Function to send data to Firebase
  Future<bool> sendData() async {
    try {
      final url = Uri.parse("https://her-6d883-default-rtdb.firebaseio.com/users.json"); // <- .json added
      //final url = Uri.parse("https://her-6d883-default-rtdb.firebaseio.com/"); // replace with your DB URL

      final data = {
        "username": username,
        "email": email,
        "password": password,
        "Contact": {
          "Name": "",
          "Relation": "",
         "Pho": ""
        },
        "liveTracking": {
          "latitude": "",
          "longitude": "",
          "status": false
        },
        "address":"",
        "phone":"",
      };

      final response = await http.post(
        url,
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Failed to post data: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
}
