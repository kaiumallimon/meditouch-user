import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class EmailVerifier {

  Future<bool> verify(String email) async {

    final apiKey = dotenv.env['ZEROBOUNCE_API_KEY'];
    String apiUrl = 'https://api.zerobounce.net/v2/validate?api_key=$apiKey&email=$email';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'valid') {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }


  Future<Map<String,dynamic>> verifyAndGetData(String email) async {
    final apiKey = dotenv.env['ZEROBOUNCE_API_KEY'];
    String apiUrl = 'https://api.zerobounce.net/v2/validate?api_key=$apiKey&email=$email';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return data;
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }
}
