// ai_chat_event.dart
import 'package:equatable/equatable.dart';

abstract class AiChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendMessageEvent extends AiChatEvent {
  final String message;

  SendMessageEvent(this.message);

  @override
  List<Object?> get props => [message];
}
