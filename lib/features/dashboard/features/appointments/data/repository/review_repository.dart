import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meditouch/features/dashboard/features/appointments/data/models/review_model.dart';

import '../../../doctors/data/models/doctor_model.dart';

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

  /// get top 5 rated doctors
  /// return: List<DoctorModel>
  /// if ther's not enough doctors, return as much as possible
  /// return type: Stream<List<DoctorModel>>

  Stream<List<Map<String, dynamic>>> getTopRatedDoctors() {
    return _firestore
        .collection('db_client_multi_doctor_reviews')
        .orderBy('rating', descending: true) // Order reviews by rating
        .snapshots()
        .asyncMap((snapshot) async {
      final doctorIds = <String>{};

      // Collect unique doctor IDs from the reviews
      snapshot.docs.forEach((doc) {
        final review = ReviewModel.fromMap(doc.data());
        doctorIds.add(review.doctorId);
      });

      if (doctorIds.isEmpty) return []; // Return empty list if no doctors found

      // Fetch doctor information for the collected doctor IDs
      final doctorDocs = await _firestore
          .collection('db_client_doctor_accountinfo')
          .where(FieldPath.documentId, whereIn: doctorIds.toList())
          .get();

      // Map doctor IDs to their reviews
      final doctorRatings = Map<String, List<ReviewModel>>.fromIterable(
        snapshot.docs,
        key: (doc) => ReviewModel.fromMap(doc.data()).doctorId,
        value: (doc) => [ReviewModel.fromMap(doc.data())],
      );

      // Combine doctor data with ratings
      final topDoctors = doctorDocs.docs.map((doc) {
        final doctorData = doc.data();
        final doctorId = doc.id;

        // Calculate average rating for the doctor
        final reviews = doctorRatings[doctorId] ?? [];
        final averageRating = reviews.isNotEmpty
            ? reviews.map((r) => r.rating).reduce((a, b) => a + b) /
                reviews.length
            : 0;

        return {
          "rating": averageRating,
          "doctor": DoctorModel(
            id: doctorId,
            name: doctorData['name'],
            email: doctorData['email'],
            phone: doctorData['phone'],
            district: doctorData['district'],
            gender: doctorData['gender'],
            dob: doctorData['dob'],
            imageUrl: doctorData['image'],
            specialization: doctorData['specialization'],
            visitingFee: doctorData['visitingFee'],
            degrees: (doctorData['degrees'] as List)
                .map((e) => DegreeModel.fromJson(e))
                .toList(),
            licenseId: doctorData['licenseId'],
            createdAt: doctorData['createdAt'],
            timeSlots: (doctorData['timeSlots'] as Map<String, dynamic>?)?.map(
                    (key, value) => MapEntry(
                        key, List<Map<String, dynamic>>.from(value))) ??
                {},
            ratings: [],
          ),
        };
      }).toList();

      // Sort by rating in descending order
      topDoctors.sort(
          (a, b) => (b["rating"] as double).compareTo(a["rating"] as double));

      return topDoctors;
    });
  }
}
