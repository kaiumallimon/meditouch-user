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

  Future<Map<String, dynamic>> addPaymentLog(
   {
    required String paymentId,
    required String transactionId,
    required double amount,
    required String currency,
    required String invoiceNumber,
    required String orderId,
    required String userId,
   }
  ) async {
    try {
      final docRef = await _firestore.collection('db_client_payment_logs').add({
        'payment_id': paymentId,
        'transaction_id': transactionId,
        'user_id': userId,
        'order_id': orderId,
        'amount': amount,
        'currency': currency,
        'invoice_number': invoiceNumber,
        'purpose': 'Medicine Purchase',
        'created_at': FieldValue.serverTimestamp(),
      });
      return {
        'status': true,
        'message': 'Payment log created successfully',
        'logId': docRef.id,
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
}
