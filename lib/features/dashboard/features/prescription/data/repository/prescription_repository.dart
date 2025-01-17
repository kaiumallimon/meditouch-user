import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditouch/features/dashboard/features/doctors/data/models/appointment_model.dart';

class PrescriptionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// store image to firebase storage and get the download url then store it
  /// with other info in local prescription collection:
  ///
  /// [image] the image to store
  /// [data] the data to store with the image

  Future<bool> storeLocalPrescription(
      {required XFile image,
      String? description,
      required String userId}) async {
    try {
      // Store image to Firebase Storage
      final ref = _storage
          .ref()
          .child('prescriptions/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = ref.putFile(File(image.path));

      // Wait for the upload to complete and get the download URL
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Store data in the Firestore collection
      await _firestore.collection('db_client_multi_local_prescriptions').add({
        'prescription': downloadUrl,
        'description': description ?? '',
        'userId': userId,
        'timeStamp': FieldValue.serverTimestamp(),
      });

      // Return success
      return true;
    } catch (e) {
      // Handle errors
      print('Error storing local prescription: $e');
      return false;
    }
  }

  Stream<List<LocalPrescriptionModel>> getLocalPrescriptions(String userId) {
    return _firestore
        .collection('db_client_multi_local_prescriptions')
        .where('userId', isEqualTo: userId) // Filter by userId
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LocalPrescriptionModel.fromMap(doc.data()))
            .toList());
  }

  Future<List<AppointmentModel>> getPastAppointments(String userId) async {
    final snapshot = await _firestore
        .collection('db_client_multi_appointments')
        .where('patientId', isEqualTo: userId)
        .where('isCompleted', isEqualTo: true)
        .get();
    return snapshot.docs
        .map((doc) => AppointmentModel.fromJson(doc.data(), doc.id))
        .toList();
  }

  Future<PrescriptionModel?> getRemotePrescription(String appointmentId) async {
    try {
      final snapshot = await _firestore
          .collection('db_client_multi_prescriptions')
          .where('appointmentId', isEqualTo: appointmentId)
          .limit(1) // Ensure only one document is fetched
          .get();

      if (snapshot.docs.isNotEmpty) {
        return PrescriptionModel.fromJson(
            snapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      print('Error fetching remote prescription: $e');
      return null;
    }
  }
}

class PrescriptionModel {
  List<MedicineModel> medicines;
  List<String> tests;
  final String appointmentId;

  PrescriptionModel({
    required this.medicines,
    required this.tests,
    required this.appointmentId,
  });

  // Factory constructor to create a PrescriptionModel from JSON
  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      medicines: (json['medicines'] as List<dynamic>)
          .map((e) => MedicineModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      tests: List<String>.from(json['tests'] ?? []),
      appointmentId: json['appointmentId'] ?? '',
    );
  }

  // Convert PrescriptionModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'medicines': medicines.map((e) => e.toJson()).toList(),
      'tests': tests,
      'appointmentId': appointmentId,
    };
  }
}

// MedicineModel to represent individual medicine details
class MedicineModel {
  String name;
  String strength;
  int days;
  int dosesPerDay;

  MedicineModel({
    required this.name,
    required this.strength,
    required this.days,
    required this.dosesPerDay,
  });

  // Factory constructor to create a MedicineModel from JSON
  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      name: json['name'] ?? '',
      strength: json['strength'] ?? '',
      days: json['days'] ?? 0,
      dosesPerDay: json['dosesPerDay'] ?? 0,
    );
  }

  // Convert MedicineModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'strength': strength,
      'days': days,
      'dosesPerDay': dosesPerDay,
    };
  }
}

class LocalPrescriptionModel {
  final String prescription;
  final String description;
  final Timestamp timeStamp;

  LocalPrescriptionModel({
    required this.prescription,
    required this.description,
    required this.timeStamp,
  });

  factory LocalPrescriptionModel.fromMap(Map<String, dynamic> map) {
    return LocalPrescriptionModel(
      prescription: map['prescription'],
      description: map['description'],
      timeStamp: map['timeStamp'],
    );
  }
}
