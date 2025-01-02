// cart_state.dart
import 'package:equatable/equatable.dart';
import 'package:meditouch/features/dashboard/features/cart/models/cart_model.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/data/model/medicine_model.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {
  const CartInitial();

  @override
  List<Object> get props => [];
}

class CartLoading extends CartState {
  const CartLoading();

  @override
  List<Object> get props => [];
}

class CartLoaded extends CartState {
  final List<CartModel> cartItems;
  final List<String> selectedItems;
  List<CartModel> get selectedCartItems => cartItems
      .where((element) => selectedItems.contains(element.cartId))
      .toList();

  const CartLoaded(this.cartItems, {this.selectedItems = const []});

  @override
  List<Object> get props => [cartItems, selectedItems];
}

class CartError extends CartState {
  final String message;
  const CartError(this.message);

  @override
  List<Object> get props => [message];
}

class CartCheckoutInitial extends CartState {
  const CartCheckoutInitial();

  @override
  List<Object> get props => [];
}

class CartCheckoutLoading extends CartState {
  const CartCheckoutLoading();

  @override
  List<Object> get props => [];
}

class CartCheckoutSuccess extends CartState {
  const CartCheckoutSuccess();

  @override
  List<Object> get props => [];
}

class CartCheckoutError extends CartState {
  final String message;
  const CartCheckoutError(this.message);

  @override
  List<Object> get props => [message];
}

class CartPaymentSate extends CartState {
  const CartPaymentSate();

  @override
  List<Object> get props => [];
}

class CartPaymentWebview extends CartState {
  final String paymentUrl;
  final String paymentId;
  final String tokenId;
  final String deliveryAddress;
  final String uid;
  final double totalAmount;
  final String userFullName;
  final String userPhone;
  final List<Medicine> medicines;

  const CartPaymentWebview(
      {required this.paymentUrl,
      required this.paymentId,
      required this.deliveryAddress,
      required this.tokenId,
      required this.uid,
      required this.totalAmount,
      required this.userFullName,
      required this.userPhone,
      required this.medicines});

  @override
  List<Object> get props => [
        paymentUrl,
        paymentId,
        tokenId,
        deliveryAddress,
        uid,
        totalAmount,
        userFullName,
        userPhone,
        medicines
      ];
}

class CartPaymentGatewaySuccess extends CartState {
  final String paymentId;
  final String transactionId;
  final String amount;
  final String currency;
  final String invoiceNumber;

  const CartPaymentGatewaySuccess(
      {required this.paymentId,
      required this.transactionId,
      required this.amount,
      required this.currency,
      required this.invoiceNumber});

  @override
  List<Object> get props => [
        paymentId,
        transactionId,
        amount,
        currency,
        invoiceNumber,
      ];
}
