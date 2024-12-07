import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:meditouch/common/repository/hive_repository.dart';

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
          'x-api-key': dotenv.env['X_API_KEY']!
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

  Future<void> logout(BuildContext context)async{
    await HiveRepository().deleteUserInfo();

    final theme = Theme.of(context).colorScheme;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: theme.surface,
      systemNavigationBarIconBrightness: theme.brightness,
    ));
    Navigator.of(context).pushReplacementNamed('/login');
  }
}
