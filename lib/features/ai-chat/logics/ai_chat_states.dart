// ai_chat_state.dart
import 'package:equatable/equatable.dart';

abstract class AiChatState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AiChatInitial extends AiChatState {}

class AiChatLoading extends AiChatState {}

class AiChatSuccess extends AiChatState {
  final String response;

  AiChatSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class AiChatError extends AiChatState {
  final String error;

  AiChatError(this.error);

  @override
  List<Object?> get props => [error];
}


class AiChatUpdated extends AiChatState {
  final List<Map<String, String>> messages;

  AiChatUpdated(this.messages);
}
