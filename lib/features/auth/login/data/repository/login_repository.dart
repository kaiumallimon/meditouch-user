import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginRepository {
  Future<Map<String, dynamic>> login(String email, String password) async {
    const String apiUrl = 'https://meditouch.bcrypt.website/auth/login';

    // Prepare the request body
    final Map<String, String> requestBody = {
      'email': email,
      'password': password,
    };

    // Make the POST request
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      // Check if the response is successful (status code 200)
      if (response.statusCode == 200) {
        // Parse and return the response body as a Map
        return json.decode(response.body);
      } else {
        return json.decode(response.body);
      }
    } catch (e) {
      return {'message': e};
    }
  }
}
