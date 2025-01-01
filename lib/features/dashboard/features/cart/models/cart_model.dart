import 'package:equatable/equatable.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/data/model/medicine_model.dart';

class CartModel extends Equatable {
  final String userId;
  final Medicine medicine;
  final int quantity;
  final int unitIndex;
  final double totalPrice;
  final double discountedPrice;
  final String cartId;

  const CartModel({
    required this.userId,
    required this.medicine,
    required this.quantity,
    required this.unitIndex,
    required this.totalPrice,
    required this.cartId,
    required this.discountedPrice,
  });

  // serialization and deserialization

  factory CartModel.fromJson(Map<String, dynamic> json, String cartId) {
    return CartModel(
      cartId: cartId,
      userId: json['user_id'],
      medicine: Medicine.fromJson(json['medicine']),
      quantity: json['quantity'],
      unitIndex: json['unit_index'],
      totalPrice: json['total_price'],
      discountedPrice: json['discounted_price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'medicine': medicine.toJson(),
      'quantity': quantity,
      'unit_index': unitIndex,
      'total_price': totalPrice,
      'discounted_price': discountedPrice,
    };
  }

  @override
  List<Object?> get props =>
      [userId, medicine, quantity, unitIndex, totalPrice];
}
