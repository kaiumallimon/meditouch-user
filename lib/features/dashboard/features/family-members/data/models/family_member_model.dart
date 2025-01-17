import 'package:cloud_firestore/cloud_firestore.dart';

class FamilyMemberModel {
  final String id;
  final String userId;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final List<PersonModel> familyMembers;

  const FamilyMemberModel({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.familyMembers,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'familyMembers': familyMembers.map((x) => x.toMap()).toList(),
    };
  }

  factory FamilyMemberModel.fromMap(Map<String, dynamic> map, String id) {
    return FamilyMemberModel(
      id: id,
      userId: map['userId'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      familyMembers: List<PersonModel>.from(
          map['familyMembers']?.map((x) => PersonModel.fromMap(x))),
    );
  }
}

class PersonModel {
  final String name;
  final String email;
  final String phoneNumber;
  final String dob;
  final String gender;
  final String relationShip;
  final String? image;

  const PersonModel({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.dob,
    required this.gender,
    required this.relationShip,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phoneNumber,
      'dob': dob,
      'gender': gender,
      'relationShip': relationShip,
      'image': image,
    };
  }

  factory PersonModel.fromMap(Map<String, dynamic> map) {
    return PersonModel(
        name: map['name'],
        email: map['email'],
        phoneNumber: map['phone'],
        dob: map['dob'],
        gender: map['gender'],
        image: map['image'],
        relationShip: map['relationShip']);
  }

  // default constructor
  factory PersonModel.defaultConstructor() {
    return const PersonModel(
      name: '',
      email: '',
      phoneNumber: '',
      dob: '',
      gender: '',
      relationShip: '',
      image: null, // nullable field can remain null
    );
  }

}
