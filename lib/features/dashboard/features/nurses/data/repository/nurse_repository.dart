import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/nurse_model.dart';

class NurseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<NurseModel>> getNurses() {
    return _firestore.collection('nurses').snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => NurseModel.fromMap(doc.data(), doc.id))
            .toList());
  }
}
