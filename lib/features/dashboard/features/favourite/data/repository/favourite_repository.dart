import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meditouch/features/dashboard/features/favourite/data/model/favourite_model.dart';

class FavouriteRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // add to favourite
  Future<Map<String, dynamic>> addToFavourite(FavouriteModel favourite) async {
    try {
      // check if the timestamp is null
      await _firestore
          .collection('db_client_user_favourite')
          .add(favourite.toJson());

      return {'status': true, 'message': 'Added to favourite'};
    } catch (e) {
      return {'status': false, 'message': e.toString()};
    }
  }

  // remove from favourite

  Future<Map<String, dynamic>> removeFromFavourite(String favouriteId) async {
    try {
      await _firestore
          .collection('db_client_user_favourite')
          .doc(favouriteId)
          .delete();

      return {'status': true, 'message': 'Removed from favourite'};
    } catch (e) {
      return {'status': false, 'message': e.toString()};
    }
  }

  // get favourite list of a user as stream

  Stream<QuerySnapshot> getFavouriteList(String uid) {
    return _firestore
        .collection('db_client_user_favourite')
        .where('user_id', isEqualTo: uid)
        .snapshots();
  }
}
