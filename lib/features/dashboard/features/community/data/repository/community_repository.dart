import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/community_model.dart';

class CommunityRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // upload image to firebase storage
  Future<String?> uploadImage(File image) async {
    try {
      final ref = _storage
          .ref()
          .child('community_images')
          .child('${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = ref.putFile(image);
      final snapshot = await uploadTask.whenComplete(() => null);
      final imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      return null;
    }
  }

  // Add a new post
  Future<bool> addPost(CommunityModel post) async {
    try {
      await _firestore
          .collection('db_client_multi_community')
          .add(post.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  // Add a reaction to a post
  Future<bool> addReact(String postId, String userId) async {
    try {
      final docRef =
          _firestore.collection('db_client_multi_community').doc(postId);
      await docRef.update({
        'reacts': FieldValue.arrayUnion([userId]),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // Toggle a reaction (add/remove)
  Future<bool> toggleReact(String postId, String userId) async {
    try {
      final docRef =
          _firestore.collection('db_client_multi_community').doc(postId);
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        final reacts = List<String>.from(data['reacts'] ?? []);
        if (reacts.contains(userId)) {
          await docRef.update({
            'reacts': FieldValue.arrayRemove([userId]),
          });
        } else {
          await docRef.update({
            'reacts': FieldValue.arrayUnion([userId]),
          });
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  // Add a comment to a post
  Future<bool> addComment(String postId, CommentModel comment) async {
    try {
      final docRef =
          _firestore.collection('db_client_multi_community').doc(postId);
      await docRef.update({
        'comments': FieldValue.arrayUnion([comment.toMap()]),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // Delete a comment from a post
  Future<bool> deleteComment(String postId, CommentModel comment) async {
    try {
      final docRef =
          _firestore.collection('db_client_multi_community').doc(postId);
      await docRef.update({
        'comments': FieldValue.arrayRemove([comment.toMap()]),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // Delete a post
  Future<bool> deletePost(String postId) async {
    try {
      await _firestore
          .collection('db_client_multi_community')
          .doc(postId)
          .delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get all posts as a stream
  Stream<List<CommunityModel>> getPosts() {
    return _firestore
        .collection('db_client_multi_community')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CommunityModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Get comments for a specific post as a stream
  Stream<List<CommentModel>> getComments(String postId) {
    return _firestore
        .collection('db_client_multi_community')
        .doc(postId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data()!;
        final comments =
            List<Map<String, dynamic>>.from(data['comments'] ?? []);
        return comments
            .map((comment) => CommentModel.fromMap(comment))
            .toList();
      } else {
        return [];
      }
    });
  }

  Stream<UserAccountModel?> getUserDataByUid(String uid) {
    return _firestore
        .collection('db_client_user_userinfo')
        .where('uid', isEqualTo: uid) // Query the collection by the 'uid' field
        .limit(1) // Assuming each user has a unique UID
        .snapshots()
        .map((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data();
        return UserAccountModel.fromMap(data);
      } else {
        return null; // Return null if no matching document is found
      }
    });
  }
}

class UserAccountModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String dob;
  final String imageUrl;

  UserAccountModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.dob,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'dob': dob,
      'image': imageUrl,
    };
  }

  factory UserAccountModel.fromMap(Map<String, dynamic> map) {
    return UserAccountModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      gender: map['gender'],
      dob: map['dob'],
      imageUrl: map['image'],
    );
  }

  // default constructor
}
