import 'package:equatable/equatable.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/data/model/medicine_model.dart';

class OrderModel extends Equatable {
  final List<Medicine> medicines;
  final String uid;
  final String orderStatus;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final String deliveryAddress;
  final String userPhoneNumber;
  final String userFullName;
  final String paymentMethod;
  final String paymentStatus;
  final double totalPrice;
  final String orderId;
  final String? orderNote;

  const OrderModel({
    required this.medicines,
    required this.uid,
    required this.orderStatus,
    required this.orderDate,
    this.deliveryDate,
    required this.deliveryAddress,
    required this.userPhoneNumber,
    required this.userFullName,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.totalPrice,
    required this.orderId,
    this.orderNote,
  });

  // serialization
  factory OrderModel.fromJson(Map<String, dynamic> json, String orderId) {
    var medicinesFromJson = json['medicines'] as List;
    List<Medicine> medicinesList = medicinesFromJson
        .map((medicineJson) => Medicine.fromJson(medicineJson))
        .toList();

    return OrderModel(
      medicines: medicinesList,
      uid: json['user_id'],
      orderStatus: json['order_status'],
      orderDate: DateTime.parse(json['order_date']),
      deliveryDate: json['delivery_date'] != null
          ? DateTime.parse(json['delivery_date'])
          : null,
      deliveryAddress: json['delivery_address'],
      userPhoneNumber: json['user_phone_number'],
      userFullName: json['user_full_name'],
      paymentMethod: json['payment_method'],
      paymentStatus: json['payment_status'],
      totalPrice: json['total_price'].toDouble(),
      orderId: orderId,
      orderNote: json['order_note'],
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> medicinesToJson =
        medicines.map((medicine) => medicine.toJson()).toList();

    return {
      'medicines': medicinesToJson,
      'user_id': uid,
      'order_status': orderStatus,
      'order_date': orderDate.toIso8601String(),
      'delivery_date': deliveryDate?.toIso8601String(),
      'delivery_address': deliveryAddress,
      'user_phone_number': userPhoneNumber,
      'user_full_name': userFullName,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'total_price': totalPrice,
      'order_note': orderNote,
    };
  }

  @override
  List<Object?> get props => [
        medicines,
        uid,
        orderStatus,
        orderDate,
        deliveryDate,
        deliveryAddress,
        userPhoneNumber,
        userFullName,
        paymentMethod,
        paymentStatus,
        totalPrice,
        orderId,
        orderNote,
      ];
}

class OrderResponse extends Equatable {
  final List<OrderModel>? orders;
  final bool status;
  final String message;

  const OrderResponse({
    this.orders,
    required this.status,
    required this.message,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    var ordersFromJson = json['orders'] as List;
    List<OrderModel> ordersList =
        ordersFromJson.map((orderJson) => OrderModel.fromJson(orderJson, ''))
            .toList();

    return OrderResponse(
      orders: ordersList,
      status: json['status'],
      message: json['message'],
    );
  }


  @override
  List<Object?> get props => [orders, status, message];
}
