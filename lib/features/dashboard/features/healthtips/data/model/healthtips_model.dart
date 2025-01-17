import 'package:cloud_firestore/cloud_firestore.dart';

class HealthTipsModel{
  final String id;
  final String title;
  final String body;
  final String doctorId;
  final Timestamp writtenTime;
  final String image;


  HealthTipsModel({
    required this.id,
    required this.title,
    required this.body,
    required this.doctorId,
    required this.writtenTime,
    required this.image,
  });

  factory HealthTipsModel.fromMap(Map<String, dynamic> map, String id){
    return HealthTipsModel(
      id: id,
      title: map['title'],
      body: map['body'],
      doctorId: map['doctorId'],
      writtenTime: map['timestamp'],
      image: map['image'],
    );
  }


  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'title': title,
      'body': body,
      'doctorId': doctorId,
      'timestamp': writtenTime,
      'image': image,
    };
  }


}