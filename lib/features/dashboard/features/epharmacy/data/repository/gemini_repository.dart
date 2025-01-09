import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiRepository {
  late String apiKey;
  GeminiRepository() {
    apiKey = dotenv.env['GEMINI_API_KEY']!;
  }

  Future<Map<String, dynamic>> analyzeMedicineImage(File imageFile) async {
    try {
      // Initialize model
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
        generationConfig: GenerationConfig(),
      );

      // Get image bytes
      Uint8List imageBytes = await getImageBytes(imageFile);

      var content = Content.multi([
        TextPart(
            "Please scan the provided medicine image and extract the medicine name and strength. Return the results in a Map format using curly braces. Include the following keys: 'name' for the medicine name, 'strength' for its strength, and 'slug' which should combine both the name and strength with a space in between. Make sure that I can parse your response directly without any additional processing."),
        DataPart('image/png', imageBytes),
      ]);

      var chat = await model.startChat();
      var response = await chat.sendMessage(content);

      log('Response text: ${response.text!}');

      // Ensure response is not null or empty
      if (response.text == null || response.text!.isEmpty) {
        return {
          'status': false,
          'message': "Empty response from the AI.",
          'response': null
        };
      }

      // Normalize the response by replacing single quotes with double quotes
      String jsonString = response.text!
          .replaceAll("'", "\"")
          .replaceAll("`", "")
          .replaceAll("json", "")
          .trim();

      log('Json String: $jsonString');

      // Validate if the string looks like JSON
      if (!jsonString.startsWith("{") || !jsonString.endsWith("}")) {
        return {
          'status': false,
          'message': "Invalid JSON format in response.",
          'response': null
        };
      }

      // Attempt to parse the JSON
      try {
        Map<String, dynamic> result =
            jsonDecode(jsonString); // Store the result in a map

        // Check if required keys exist
        if (!result.containsKey('name') || !result.containsKey('strength')) {
          return {
            'status': false,
            'message': "This is not a valid medicine image.",
            'response': null
          };
        }

        // Return structured response for success
        return {
          'status': true,
          'message': "Medicine image analyzed successfully.",
          'response': result
        };
      } catch (e) {
        log('JSON Parsing Error: $e');
        return {
          'status': false,
          'message': "Unable to parse the image response.",
          'response': null
        };
      }
    } catch (e) {
      log("Error analyzing medicine image: $e");
      return {
        'status': false,
        'message': "Error analyzing the medicine image: $e",
        'response': null
      };
    }
  }

  Future<Uint8List> getImageBytes(File imageFile) async {
    try {
      return await imageFile.readAsBytes();
    } catch (e) {
      throw Exception("Failed to read image file: $e");
    }
  }
}
