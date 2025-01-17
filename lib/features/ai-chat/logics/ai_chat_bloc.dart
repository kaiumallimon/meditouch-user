// ai_chat_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/features/ai-chat/data/repository/ai_chat_repository.dart';

import 'ai_chat_events.dart';
import 'ai_chat_states.dart';

class AiChatBloc extends Bloc<AiChatEvent, AiChatState> {
  final AiChatRepository repository;

  // Store messages
  final List<Map<String, String>> messages = [];

  AiChatBloc(this.repository) : super(AiChatInitial()) {
    on<SendMessageEvent>((event, emit) async {
      // Add user's message to the list
      messages.add({'sender': 'user', 'text': event.message});
      emit(AiChatUpdated(messages));

      // Add "Loading..." placeholder
      messages.add({'sender': 'ai', 'text': 'Loading...'});
      emit(AiChatUpdated(messages));

      try {
        // Get response from AI
        final response = await repository.getChatResponse(event.message);
        final responseMessage = response?['response'] ?? 'No response';

        // Replace "Loading..." with AI's response
        messages.removeLast(); // Remove the loading message
        messages.add({'sender': 'ai', 'text': responseMessage});
        emit(AiChatUpdated(messages));
      } catch (error) {
        // Handle error and remove "Loading..." placeholder
        messages.removeLast();
        messages.add({'sender': 'ai', 'text': 'Something went wrong!'});
        emit(AiChatUpdated(messages));
      }
    });
  }
}
