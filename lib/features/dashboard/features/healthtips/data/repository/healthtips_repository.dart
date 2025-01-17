import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meditouch/features/dashboard/features/doctors/data/models/doctor_model.dart';

import '../model/healthtips_model.dart';

class HealthTipsRepository{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<HealthTipsModel>> getHealthTips() {
    return _firestore
        .collection('db_client_multi_health_tips')
        .orderBy('timestamp', descending: true) // Order by the timestamp field
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => HealthTipsModel.fromMap(doc.data(), doc.id))
        .toList());
  }

  Stream<DoctorModel> getDoctorById(String id) {
    return _firestore
        .collection('db_client_doctor_accountinfo')
        .doc(id)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data();
      return DoctorModel.fromJson(data!, snapshot.id);
    });
  }

}