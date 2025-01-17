import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityModel {
  final String id;
  final String? image;
  final String text;
  final String postedBy;
  final Timestamp postTime;
  final List<String> reacts;
  final List<CommentModel> comments;

  CommunityModel({
    required this.id,
    required this.image,
    required this.text,
    required this.postedBy,
    required this.postTime,
    required this.reacts,
    required this.comments,
  });

  // Convert Firestore data to CommunityModel
  factory CommunityModel.fromMap(Map<String, dynamic> map, String id) {
    return CommunityModel(
      id: id,
      image: map['image'],
      text: map['text'] ?? '',
      postedBy: map['postedBy'] ?? '',
      postTime: (map['postTime'] as Timestamp),
      reacts: (map['reacts'] as List<dynamic>).map((e) => e as String).toList(),
      comments: (map['comments'] as List<dynamic>)
          .map((e) => CommentModel.fromMap(e))
          .toList(),
    );
  }

  // Convert CommunityModel to Firestore data
  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'text': text,
      'postedBy': postedBy,
      'postTime': postTime,
      'reacts': reacts,
      'comments': comments.map((e) => e.toMap()).toList(),
    };
  }
}

class ReactModel {
  final String userId;

  ReactModel({required this.userId});

  // Convert Firestore data to ReactModel
  factory ReactModel.fromMap(String userId) {
    return ReactModel(userId: userId);
  }

  // Convert ReactModel to Firestore data
  String toMap() => userId;
}

class CommentModel {
  final String commentText;
  final String commenterId;

  CommentModel({
    required this.commentText,
    required this.commenterId,
  });

  // Convert Firestore data to CommentModel
  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      commentText: map['commentText'] ?? '',
      commenterId: map['commenterId'] ?? '',
    );
  }

  // Convert CommentModel to Firestore data
  Map<String, dynamic> toMap() {
    return {
      'commentText': commentText,
      'commenterId': commenterId,
    };
  }
}
