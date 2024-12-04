import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart'; // To check mime type
import 'package:http_parser/http_parser.dart'; // For MediaType parsing

class RegistrationRepository {
  Future<Map<String,dynamic>> register(String name, String phone, String email,
      String gender, DateTime dob, String password, XFile? image) async {
    const String apiUrl = 'https://meditouch.bcrypt.website/auth/register';

    var request = http.MultipartRequest("POST", Uri.parse(apiUrl));

    // Add form fields
    request.fields['name'] = name;
    request.fields['phone'] = phone;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['gender'] = gender;
    request.fields['dob'] = dob.toIso8601String(); // Using ISO8601 format for date

    // Check if image is not null
    if (image != null) {
      var imageBytes = await image.readAsBytes(); // Read image as bytes
      var imageMimeType = lookupMimeType(image.path) ?? 'image/jpeg'; // Lookup mime type

      // Create multipart file for image
      var multipartFile = http.MultipartFile.fromBytes(
        'profileImage', // The field name (must match the backend field)
        imageBytes,
        filename: image.path.split('/').last,
        contentType: MediaType.parse(imageMimeType),
      );

      request.files.add(multipartFile); // Add the file to the request
    }

    // Send the request to the API
    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);

        return {
          'status': 'success',
          'message': 'Account created successfully!'
        };
      } else {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);
        return jsonResponse;
      }
    } catch (e) {
      return {
        'message': e
      };
    }
  }
}
