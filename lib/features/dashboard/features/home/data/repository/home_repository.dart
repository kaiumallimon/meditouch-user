import 'package:cloud_firestore/cloud_firestore.dart';

class HomeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get cart items count by user id

  Future<int> getCartItemsCount(String userId) async {
    final cartItems = await _firestore
        .collection('db_client_user_cart')
        .where('user_id', isEqualTo: userId)
        .get();

    // print
    print('cartItems.docs.length: ${cartItems.docs.length}');
    return cartItems.docs.length;
  }
}
