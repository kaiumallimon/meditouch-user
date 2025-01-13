import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meditouch/features/dashboard/features/doctors/data/models/doctor_model.dart';

class DoctorRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// fetchDoctors
  ///
  /// function to fetch doctors from firestore
  ///
  /// returns a list of doctors

  Future<List<DoctorModel>> fetchDoctors() async {
    try {
      final doctors =
          await _firestore.collection('db_client_doctor_accountinfo').get();
      return doctors.docs //
          .map((e) => DoctorModel.fromJson(e.data(), e.id))
          .toList();
    } on Exception catch (e) {
      log(e.toString());
      return [];
    }
  }
}
