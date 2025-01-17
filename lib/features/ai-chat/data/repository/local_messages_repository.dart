
import 'package:hive_flutter/hive_flutter.dart';

class LocalAiMessageRepository {
  final Box _chatBox;

  LocalAiMessageRepository() : _chatBox = Hive.box('chatMessages');

  /// Retrieve all messages from the Hive box
  List<Map<String, dynamic>> getMessages() {
    // Retrieve the stored messages or default to an empty list
    final storedMessages = _chatBox.get('messages', defaultValue: <dynamic>[]);
    try {
      // Safely cast each message to Map<String, dynamic>
      return List<Map<String, dynamic>>.from(
        storedMessages.map((message) => Map<String, dynamic>.from(message)),
      );
    } catch (e) {
      // If there's an error in the data, return an empty list
      print('Error retrieving messages: $e');
      return [];
    }
  }

  /// Add a new message to the Hive box
  Future<void> addMessage(Map<String, dynamic> message) async {
    final messages = getMessages();
    messages.add(message);
    await _chatBox.put('messages', messages);
  }

  /// Remove a message by index
  Future<void> removeMessage(int index) async {
    final messages = getMessages();
    if (index >= 0 && index < messages.length) {
      messages.removeAt(index);
      await _chatBox.put('messages', messages);
    }
  }

  /// Clear all messages
  Future<void> clearMessages() async {
    await _chatBox.put('messages', []);
  }
}
