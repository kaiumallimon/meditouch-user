import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<Map<String, dynamic>> register(String name, String phone, String email,
      String gender, DateTime dob, String password, XFile? image) async {
    try {
      // Create user with Firebase Auth
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the Firebase User object
      User? user = userCredential.user;
      if (user == null) {
        return {
          'status': 'error',
          'message': 'User registration failed. Please try again.',
        };
      }

      // Upload profile image to Firebase Storage (if an image is provided)
      String? imageUrl;
      if (image != null) {
        // Generate a unique filename for the image
        String fileName =
            'profile_images/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg';

        // Upload the image to Firebase Storage
        try {
          UploadTask uploadTask =
              _storage.ref(fileName).putData(await image.readAsBytes());
          TaskSnapshot snapshot = await uploadTask;
          imageUrl = await snapshot.ref.getDownloadURL();
        } catch (e) {
          return {
            'status': 'error',
            'message': 'Error uploading image: $e',
          };
        }
      }

      // Save user data to Firestore
      await _firestore.collection('db_client_user_userinfo').doc(user.uid).set({
        'name': name,
        'phone': phone,
        'email': email,
        'gender': gender,
        'dob': dob.toIso8601String(),
        'image': imageUrl,
        'uid': user.uid,
      });

      return {
        'status': 'success',
        'message': 'Account created successfully!',
        'user': {
          'id': user.uid,
          'name': name,
          'email': email,
          'phone': phone,
          'gender': gender,
          'dob': dob.toIso8601String(),
          'image': imageUrl,
        },
      };
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth errors
      switch (e.code) {
        case 'email-already-in-use':
          return {
            'status': 'error',
            'message':
                'The email address is already in use by another account.',
          };
        case 'invalid-email':
          return {
            'status': 'error',
            'message': 'The email address is not valid.',
          };
        case 'weak-password':
          return {
            'status': 'error',
            'message': 'The password is too weak.',
          };
        default:
          return {
            'status': 'error',
            'message':
                'An error occurred during registration. Please try again.',
          };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'An error occurred during registration: $e',
      };
    }
  }
}
