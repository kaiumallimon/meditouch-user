import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditouch/features/dashboard/features/doctors/data/models/doctor_model.dart';
import 'package:meditouch/features/dashboard/features/messages/data/model/message_model.dart';

class MessagesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  ///
  /// Find doctors whose appointments are booked
  /// by the user
  ///
  Future<List<DoctorModel>> findDoctorsWithAppointments(String userId) async {
    try {
      // Find all appointments of the user
      final QuerySnapshot<Map<String, dynamic>> appointments = await _firestore
          .collection('db_client_multi_appointments')
          .where('patientId', isEqualTo: userId)
          .get();

      // Extract unique doctor IDs from the appointments
      final Set<String> doctorIds = appointments.docs
          .map((doc) => doc.data()['doctorId'] as String)
          .toSet(); // Use Set to ensure uniqueness

      if (doctorIds.isEmpty) {
        return []; // Return an empty list if no doctor IDs found
      }

      // Batch-fetch doctor documents using a whereIn query
      final QuerySnapshot<Map<String, dynamic>> doctorsSnapshot =
          await _firestore
              .collection('db_client_doctor_accountinfo')
              .where(FieldPath.documentId, whereIn: doctorIds.toList())
              .get();

      // Map the doctor documents to a list of DoctorModel
      final List<DoctorModel> doctors = doctorsSnapshot.docs
          .map((doc) => DoctorModel.fromJson(doc.data(), doc.id))
          .toList();

      return doctors; // Return the list of DoctorModel
    } catch (e) {
      print('Error fetching doctors: $e');
      return []; // Return an empty list in case of an error
    }
  }

  ///
  ///
  ///
  /// get all messages of a conversation
  ///
  Stream<List<MessageModel>> getMessages(String conversationId) {
    return _firestore
        .collection('db_client_multi_messages')
        .where('conversationId', isEqualTo: conversationId)
        .orderBy('timestamp') // Ensure sorting by timestamp
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }


  ////
  ///
  /// send a message
  /// 
  /// 
  Future<bool> sendMessage(String conversationId, MessageModel message)async{
    try {
      _firestore.collection('db_client_multi_messages').add(message.toMap());
      _firestore.collection('db_client_multi_conversations').doc(conversationId).update({
        'lastMessage': message.content,
        'lastMessageType': message.type,
        'lastTimeStamp': message.timestamp,
        'isRead': false,
        'from': message.from,
      });
      return true;
    } catch (e) {
      print('Error sending message: $e');
      return false;
    }
  }

  ///
  ///
  ///
  /// Create a new conversation between the user and the doctor

  Future<String> createConversation(String userId, String doctorId) async {
    // Check if a conversation already exists between the user and the doctor
    final querySnapshot = await _firestore
        .collection('db_client_multi_conversations')
        .where('doctorId', isEqualTo: doctorId)
        .where('patientId', isEqualTo: userId)
        .limit(1) // Limit to one to check existence
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // If a conversation exists, return its ID
      return querySnapshot.docs.first.id;
    } else {
      // If no conversation exists, create a new one
      final newConversationRef =
          await _firestore.collection('db_client_multi_conversations').add({
        'doctorId': doctorId,
        'patientId': userId,
        'lastMessage': '',
        'lastMessageType': 'text',
        'lastTimeStamp': FieldValue.serverTimestamp(),
        'isRead': false, // Assuming default unread status
        'from': 'patient', // Adjust as necessary based on your logic
        'typing': false,
      });

      // Return the new conversation ID
      return newConversationRef.id;
    }
  }

  /// get conversation by id

  Future<ConversationModel> getConversation(String conversationId) async {
    final doc = await _firestore
        .collection('db_client_multi_conversations')
        .doc(conversationId)
        .get();
    return ConversationModel.fromMap(doc.data()!, doc.id);
  }

  // 'doctorId': doctorId,
  //     'patientId': patientId,
  //     'lastMessage': lastMessage,
  //     'lastMessageType': lastMessageType,
  //     'isRead': isRead,
  //     'from': from,
  //     'lastTimeStamp': lastTimeStamp,

  // ///
  // ///
  // ///
  // /// Delete a conversation and its messages

  // Future<bool> deleteConversation(String conversationId) async {
  //   try {

  //     await _firestore.collection('db_client_multi_conversationss').doc(conversationId).delete();

  //     QuerySnapshot messageSnapshot = await _firestore
  //         .collection('db_client_multi_messages')
  //         .where('conversationId', isEqualTo: conversationId)
  //         .get();

  //     for (var doc in messageSnapshot.docs) {
  //       await doc.reference.delete();
  //     }

  //     return true;
  //   } catch (e) {
  //     print("Error deleting conversation: $e");
  //     return false;
  //   }
  // }

  ///
  ///
  /// Send a message

  // Future<bool> sendImage(XFile image, String conversationId,
  //     MessageModel message) async {
  //   try {

  //     String fileName =
  //         DateTime.now().millisecondsSinceEpoch.toString();
  //     Reference reference = _storage.ref().child('images/$fileName');
  //     await reference.putFile(File(image.path));

  //     String downloadUrl = await reference.getDownloadURL();

  //     // await _firestore.collection('messages').add({
  //     //   'isRead': messageData['isRead'],
  //     //   'receiverId': messageData['receiverId'],
  //     //   'type': messageData['type'],
  //     //   'content': downloadUrl,
  //     //   'senderId': messageData['senderId'],
  //     //   'conversationId': conversationId,
  //     //   'timestamp':
  //     //       messageData['timestamp'],
  //     //   'from': messageData['from']
  //     // });

  //     await _firestore.collection('conversations').doc(conversationId).update({
  //       'lastMessage': downloadUrl,
  //       'lastTimeStamp': messageData['timestamp'],
  //       'isRead': messageData['isRead'],
  //       'from': messageData['from'],
  //       'lastMessageType': messageData['type']
  //     });

  //     return true;
  //   } catch (e) {
  //     print('Error uploading image: $e');

  //     return false;
  //   }
  // }
}
