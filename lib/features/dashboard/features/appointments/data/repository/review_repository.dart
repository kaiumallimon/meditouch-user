import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meditouch/features/dashboard/features/appointments/data/models/review_model.dart';

class ReviewRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // add review
  // param: reviewmodel,
  // return: bool

  Future<bool> addReview(ReviewModel reviewModel) async {
    try {
      final docRef = await _firestore
          .collection('db_client_multi_doctor_reviews')
          .add(reviewModel.toMap());
      return docRef.id.isNotEmpty;
    } catch (e) {
      return false;
    }
  }


  Future<double> calculateRating(String doctorId) async {
    try {
      final snapshot = await _firestore
          .collection('db_client_multi_doctor_reviews')
          .where('doctorId', isEqualTo: doctorId)
          .get();
      if (snapshot.docs.isNotEmpty) {
        final totalRating = snapshot.docs
            .map((doc) => ReviewModel.fromMap(doc.data()).rating)
            .reduce((value, element) => value + element);
        return totalRating / snapshot.docs.length;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }
}
