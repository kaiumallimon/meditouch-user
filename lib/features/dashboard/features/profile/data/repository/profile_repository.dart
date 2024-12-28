import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileRepository {
  // Initialize Firestore database
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Update user profile
  Future<Map<String, dynamic>> update(
      String uid,
      Map<String, dynamic> updatedData,
      Map<String, dynamic> oldData,
      XFile? image) async {
    try {
      // Remove unchanged fields from updatedData
      updatedData.removeWhere((key, value) => oldData[key] == value);

      // Check if any field remains to be updated
      if (updatedData.isEmpty && image == null) {
        return {'status': true, 'message': 'No changes detected.'};
      }

      // Check if the image is being updated
      if (image != null) {
        // Upload the new image to Firebase Storage
        try {
          final ref = _storage.ref().child('user_images/$uid/${image.name}');
          await ref.putFile(File(image.path));
          final newImageUrl = await ref.getDownloadURL();
          updatedData['image'] =
              newImageUrl; // Update the image field with the new URL
        } catch (e) {
          return {
            'status': false,
            'message': 'Failed to upload new image: ${e.toString()}'
          };
        }
      }

      // Ensure the user document exists
      final userDoc =
          await _firestore.collection('db_client_user_userinfo').doc(uid).get();
      if (!userDoc.exists) {
        return {'status': false, 'message': 'User document not found.'};
      }

      // Update only the changed fields in Firestore
      await _firestore
          .collection('db_client_user_userinfo')
          .doc(uid)
          .update(updatedData);

      // Fetch the updated user data
      final updatedUserDoc =
          await _firestore.collection('db_client_user_userinfo').doc(uid).get();
      final updatedUserData = updatedUserDoc.data();

      return {
        'status': true,
        'message': 'Profile updated successfully',
        'data': updatedUserData
      };
    } catch (e) {
      return {
        'status': false,
        'message': 'Failed to update profile: ${e.toString()}'
      };
    }
  }
}
