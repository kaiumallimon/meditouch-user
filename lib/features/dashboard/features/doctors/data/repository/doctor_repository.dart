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

  /// Fetch the last day of the doctor's schedule
  ///
  ///

  Future<DateTime> fetchLastDayOfDoctorSchedule(String doctorId) async {
    try {
      final doctorSchedule = await _firestore
          .collection('db_client_doctor_accountinfo')
          .doc(doctorId)
          .get();

      // Check if the document exists and contains the 'timeslots' field
      if (doctorSchedule.exists && doctorSchedule.data() != null) {
        final data = doctorSchedule.data()!;
        if (data.containsKey('timeslots')) {
          // Get the timeslots map
          final timeslots = data['timeslots'] as Map<String, dynamic>;

          // Sort the keys (dates) in ascending order
          final sortedKeys = timeslots.keys.toList()..sort();

          // Get the last key
          final lastKey = sortedKeys.last;

          // Parse the last key into a DateTime object
          return DateTime.parse(lastKey);
        }
      }

      // Log if the timeslots field is missing
      log('Timeslots not found for doctorId: $doctorId');
      return DateTime.now();
    } catch (e) {
      // Log the error and return the current date as fallback
      log('Error fetching last day of doctor schedule: ${e.toString()}');
      return DateTime.now();
    }
  }

  // get all doctors
  // return a list of doctors
  // type: Stream<List<DoctorModel>>

  Stream<List<DoctorModel>> getDoctors() {
    return _firestore
        .collection('db_client_doctor_accountinfo')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((e) => DoctorModel.fromJson(e.data(), e.id))
            .toList());
  }
}
