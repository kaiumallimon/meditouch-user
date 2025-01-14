
// // conversation event
// import 'dart:async';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:meditouch/features/dashboard/features/messages/data/model/message_model.dart';

// import '../data/repository/messages_repository.dart';

// abstract class ConversationEvent {}

// class LoadConversationEvent extends ConversationEvent {
//   final String conversationId;

//   LoadConversationEvent({required this.conversationId});
// }

// class CreateConversationEvent extends ConversationEvent {
//   final String userId;
//   final String doctorId;

//   CreateConversationEvent({required this.userId, required this.doctorId});
// }

// class SendMessage extends ConversationEvent {
//   final MessageModel message;
//   final ConversationModel conversation;

//   SendMessage({required this.message, required this.conversation});
// }


// // conversation state
// abstract class ConversationState {}

// class ConversationStateInitial extends ConversationState {}

// class ConversationStateLoading extends ConversationState {}

// class ConversationStateLoaded extends ConversationState {
//   final ConversationModel conversation;
//   final List<MessageModel> messages;

//   ConversationStateLoaded({required this.conversation, required this.messages});
// }

// class ConversationStateError extends ConversationState {
//   final String message;

//   ConversationStateError({required this.message});
// }

// // conversation bloc
// class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
//   ConversationBloc() : super(ConversationStateInitial()) {
//     on<LoadConversationEvent>(_onLoadConversationEvent);
//     on<CreateConversationEvent>(_onCreateConversationEvent);
//     on<SendMessage>(_onSendMessage);
//   }

//   FutureOr<void> _onLoadConversationEvent(
//       LoadConversationEvent event, Emitter<ConversationState> emit) async {
//     emit(ConversationStateLoading());

//     try {
//       final conversation = await MessagesRepository().getConversation(event.conversationId);
//       final messages = await MessagesRepository().getMessages(event.conversationId);

//       emit(ConversationStateLoaded(conversation: conversation, messages: messages));
//     } catch (e) {
//       emit(ConversationStateError(message: 'Error loading conversation: $e'));
//     }
//   }

//   FutureOr<void> _onCreateConversationEvent(
//       CreateConversationEvent event, Emitter<ConversationState> emit) async {
//     emit(ConversationStateLoading());

//     try {
//       final conversation = await MessagesRepository().createConversation(event.userId, event.doctorId);
//       final messages = await MessagesRepository().getMessages(conversation.id);

//       emit(ConversationStateLoaded(conversation: conversation, messages: messages));
//     } catch (e) {
//       emit(ConversationStateError(message: 'Error creating conversation: $e'));
//     }
//   }

//   FutureOr<void> _onSendMessage(
//       SendMessage event, Emitter<ConversationState> emit) async {
//     emit(ConversationStateLoading());

//     try {
//       await MessagesRepository().sendMessage(event.message, event.conversation);
//       final messages = await MessagesRepository().getMessages(event.conversation.id);

//       emit(ConversationStateLoaded(conversation: event.conversation, messages: messages));
//     } catch (e) {
//       emit(ConversationStateError(message: 'Error sending message: $e'));
//     }
//   }
// }