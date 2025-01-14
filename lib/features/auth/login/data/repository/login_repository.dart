import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meditouch/common/repository/hive_repository.dart';
import 'package:http/http.dart' as http;

class LoginRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Sign in the user
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user
      final User? user = userCredential.user;

      // Check if the user is null
      if (user == null) {
        return {
          "status": "error",
          "error": "User not found. Please check your credentials."
        };
      }

      // Get the user data from Firestore
      final DocumentSnapshot snapshot = await _firestore
          .collection('db_client_user_userinfo')
          .doc(user.uid)
          .get();

      // Check if the document exists
      if (!snapshot.exists) {
        return {
          "status": "error",
          "error": "User data not found in the database."
        };
      }

      // Cast the data to a map
      final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      // Add UID to the data
      data['id'] = user.uid;

      // Return the user data
      return {"status": "success", "message": "Login successful", "user": data};
    } catch (e) {
      // Catch different types of errors and provide more specific error messages
      if (e is FirebaseAuthException) {
        return {
          "status": "error",
          "error": e.message ?? "An unknown error occurred."
        };
      } else if (e is FirebaseException) {
        return {
          "status": "error",
          "error":
              "An error occurred while connecting to the Firestore database."
        };
      } else {
        return {
          "status": "error",
          "error": "An unexpected error occurred. Please try again."
        };
      }
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await HiveRepository().deleteUserInfo();
      // ));
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      // Handle errors during logout
      print('Error during logout: $e');
      // Optionally, you can show a message or log the error
    }
  }

  // function to get the build ID from the server
  Future<Map<String, String>> getEpharmacyBuildId() async {
    try {
      // Get URL from .env
      final String url = dotenv.env['EPHARMACY_BUILD_ID_URL'] ?? '';

      // Check if the URL is not empty
      if (url.isEmpty) {
        print("ID: ${dotenv.env['EPHARMACY_BUILD_ID_URL']}");
        return {
          "status": "error",
          "error":
              "EPHARMACY_BUILD_ID_URL is not set in the environment variables."
        };
      }

      // Make a GET request
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'x-api-key': dotenv.env['SERVER_API_KEY'] ?? '',
      });

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Parse the response body
        final responseBody = jsonDecode(response.body);

        // Get the build ID
        final String buildId = responseBody['buildId'];

        // Return the build ID
        return {
          "status": "success",
          "build_id": buildId,
        };
      } else {
        return {
          "status": "error",
          "error":
              "Failed to fetch build ID. Status code: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {
        "status": "error",
        "error": "An unexpected error occurred. Please try again."
      };
    }
  }
}
