import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meditouch/features/dashboard/features/cart/models/cart_model.dart';

class CartRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // add to cart
  Future<Map<String, dynamic>> addToCart(CartModel cartModel) async {
    try {
      // check if the timestamp is null
      await _firestore
          .collection('db_client_user_cart')
          .add(cartModel.toJson());

      return {'status': true, 'message': 'Added to cart'};
    } catch (e) {
      return {'status': false, 'message': e.toString()};
    }
  }

  // remove from cart
  Future<Map<String, dynamic>> removeFromCart(String cartId) async {
    try {
      await _firestore.collection('db_client_user_cart').doc(cartId).delete();

      return {'status': true, 'message': 'Removed from cart'};
    } catch (e) {
      return {'status': false, 'message': e.toString()};
    }
  }

  // get cart list of a user by uid as future
  Future<List<CartModel>> getCartList(String uid) async {
    try {
      final snapshot = await _firestore
          .collection('db_client_user_cart')
          .where('user_id', isEqualTo: uid)
          .get();

      return snapshot.docs
          .map((doc) => CartModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
