import '../../../../common/repository/hive_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AiChatRepository {
  Future<Map<String, dynamic>?> getChatResponse(String query) async {
    try {
      // Retrieve user id from Hive repository
      final user = await HiveRepository().getUserInfo();
      if (user == null) {
        throw Exception("User information is not available");
      }
      final userId = user['id'];

      print('User ID: $userId');

      // API URL and headers
      const String apiUrl = "https://medibot-backend.vercel.app/api/chat";
      var headers = {
        'Cookie':
        'connect.sid=s%3AkAJXKyNzh-EDd-iHS3pchPKymbGeXo8J.3%2Fe8gggD1xdz9J9jqiiLSyBhZ7SM%2FKDBVLB9wDqETF0',
        'Content-Type': 'application/json',
        'x-api-key': 'p5xBzm5vWlni1f9VertqKkdOgUJaQCcX'
      };

      // Create and send the request
      final request = http.Request('POST', Uri.parse(apiUrl));
      request.body = json.encode({
        "userId": userId,
        "message": query,
      });
      request.headers.addAll(headers);

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final decodedResponse = json.decode(responseBody) as Map<String, dynamic>;
        print('Response: $decodedResponse');
        return decodedResponse;
      } else {
        final errorBody = await response.stream.bytesToString();
        print('Error Response: $errorBody');
        return null;
      }
    } catch (e) {
      print('An error occurred: $e');
      return null;
    }
  }
}
