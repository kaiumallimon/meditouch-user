import 'package:equatable/equatable.dart';

class DoctorModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String district;
  final String gender;
  final String dob;
  final String imageUrl;
  final String specialization;
  final String visitingFee;
  final List<DegreeModel> degrees;
  final String licenseId;
  final String createdAt;
  final Map<String, dynamic> timeSlots;

  const DoctorModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.district,
    required this.gender,
    required this.dob,
    required this.imageUrl,
    required this.specialization,
    required this.visitingFee,
    required this.degrees,
    required this.licenseId,
    required this.createdAt,
    required this.timeSlots,
  });

  factory DoctorModel.fromJson(dynamic json, String id) {
    return DoctorModel(
      id: id,
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      district: json['district'],
      gender: json['gender'],
      dob: json['dob'],
      imageUrl: json['image'],
      specialization: json['specialization'],
      visitingFee: json['visitingFee'],
      degrees: (json['degrees'] as List)
          .map((e) => DegreeModel.fromJson(e))
          .toList(),
      licenseId: json['licenseId'],
      createdAt: json['createdAt'],
      timeSlots: json['timeslots'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'district': district,
      'gender': gender,
      'dob': dob,
      'image': imageUrl,
      'specialization': specialization,
      'visitingFee': visitingFee,
      'degrees': degrees.map((e) => e.toJson()).toList(),
      'licenseId': licenseId,
      'createdAt': createdAt,
      'timeslots': timeSlots,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        district,
        gender,
        dob,
        imageUrl,
        specialization,
        visitingFee,
        degrees,
        licenseId,
        createdAt,
        timeSlots,
      ];
}

class DegreeModel extends Equatable {
  final String degree;
  final String institute;
  final String year;

  const DegreeModel({
    required this.degree,
    required this.institute,
    required this.year,
  });

  @override
  List<Object?> get props => [degree, institute, year];

  factory DegreeModel.fromJson(dynamic json) {
    return DegreeModel(
      degree: json['degree'],
      institute: json['institution'],
      year: json['passedYear'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'degree': degree,
      'institute': institute,
      'passedYear': year,
    };
  }

  List<DegreeModel> getDegrees(List<dynamic> json) {
    return json.map((e) => DegreeModel.fromJson(e)).toList();
  }
}
