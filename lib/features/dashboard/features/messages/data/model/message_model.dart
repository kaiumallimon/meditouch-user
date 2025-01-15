import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String? id;
  final String conversationId;
  final String senderId;
  final String receiverId;
  final String content;
  final String type;
  final String from;
  final bool isRead;
  final Timestamp timestamp;

  MessageModel({
    this.id,
    required this.conversationId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.type,
    required this.from,
    required this.isRead,
    required this.timestamp,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map, String id) {
    return MessageModel(
      id: id,
      conversationId: map['conversationId'],
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      content: map['content'],
      type: map['type'],
      from: map['from'],
      isRead: map['isRead'],
      timestamp: map['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'conversationId': conversationId,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'type': type,
      'from': from,
      'isRead': isRead,
      'timestamp': timestamp,
    };
  }
}

class ConversationModel{
  final String id;
  final String doctorId;
  final String patientId;
  final String lastMessage;
  final String lastMessageType;
  final bool isRead;
  final String from;
  final Timestamp lastTimeStamp;

  ConversationModel({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.lastMessage,
    required this.lastMessageType,
    required this.isRead,
    required this.from,
    required this.lastTimeStamp,
  });

  factory ConversationModel.fromMap(Map<String, dynamic> map, String id) {
    return ConversationModel(
      id: id,
      doctorId: map['doctorId'],
      patientId: map['patientId'],
      lastMessage: map['lastMessage'],
      lastMessageType: map['lastMessageType'],
      isRead: map['isRead'],
      from: map['from'],
      lastTimeStamp: map['lastTimeStamp'],
    );
  } 

  Map<String, dynamic> toMap() {
    return {
      'doctorId': doctorId,
      'patientId': patientId,
      'lastMessage': lastMessage,
      'lastMessageType': lastMessageType,
      'isRead': isRead,
      'from': from,
      'lastTimeStamp': lastTimeStamp,
    };
  } 
}