import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/emergency_model.dart';

class FirebaseEmergencyService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendEmergencyRequest(Map<String,dynamic> data){
    return _firestore.collection('emergencies').add(data);
  }


  Stream<List<EmergencyDoctorModel>> getEmergencyDoctors() {
    return _firestore.collection('emergency_doctors').snapshots().map(
            (snapshot) => snapshot.docs
            .map((doc) => EmergencyDoctorModel.fromMap(doc.data(), doc.id))
            .toList());
  }
}