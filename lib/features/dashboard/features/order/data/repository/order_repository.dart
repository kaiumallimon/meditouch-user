import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meditouch/features/dashboard/features/order/data/models/order_model.dart';

class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create order
  Future<Map<String, dynamic>> createOrder(OrderModel orderModel) async {
    try {
      final docRef = await _firestore
          .collection('db_client_user_orders')
          .add(orderModel.toJson());
      return {
        'status': true,
        'message': 'Order created successfully',
        'orderId': docRef.id,
      };
    } on FirebaseException catch (e) {
      // Firebase-specific error
      return {
        'status': false,
        'message': 'Firebase error: ${e.message}',
        'code': e.code,
      };
    } catch (e) {
      // Other errors
      return {
        'status': false,
        'message': 'An unexpected error occurred: $e',
      };
    }
  }

  // Get orders of a user by uid
  Future<OrderResponse> getOrders(String uid) async {
    try {
      final snapshot = await _firestore
          .collection('db_client_user_orders')
          .where('user_id', isEqualTo: uid)
          .get();

      if (snapshot.docs.isEmpty) {
        return const OrderResponse(
          status: true,
          message: 'No orders found for the user',
          orders: [],
        );
      }

      final orders = snapshot.docs.map((doc) {
        final data = doc.data();
        return OrderModel.fromJson(data, doc.id);
      });

      return OrderResponse(
        status: true,
        message: 'Orders fetched successfully',
        orders: orders.toList(),
      );
    } on FirebaseException catch (e) {
      return OrderResponse(
        status: false,
        message: 'Firebase error: ${e.message}',
        orders: const [],
      );
    } catch (e) {
      return OrderResponse(
        status: false,
        message: 'An unexpected error occurred: $e',
        orders: const [],
      );
    }
  }
}
