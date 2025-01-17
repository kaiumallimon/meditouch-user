import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../prescription/data/repository/prescription_repository.dart';

class AutomaticOrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<MedicineModel>> getMedicines(String appointmentId) async {
    try {
      final snapshot = await _firestore
          .collection('db_client_multi_prescriptions')
          .where('appointmentId', isEqualTo: appointmentId)
          .limit(1) // Ensure only one document is fetched
          .get();

      if (snapshot.docs.isNotEmpty) {
        final prescription =
            PrescriptionModel.fromJson(snapshot.docs.first.data());
        return prescription.medicines;
      }
      return [];
    } catch (e) {
      print('Error fetching remote prescription: $e');
      return [];
    }
  }
}
