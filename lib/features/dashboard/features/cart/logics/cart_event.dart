// cart_event.dart
import 'package:meditouch/features/dashboard/features/order/data/models/order_model.dart';

abstract class CartEvent {}

class LoadCart extends CartEvent {
  LoadCart();
}

class RemoveFromCart extends CartEvent {
  final List<String> cartIds;
  RemoveFromCart(this.cartIds);
}

class FilterCart extends CartEvent {
  final String sortBy; // "createdAt" or "totalPrice"
  final bool ascending; // true for ascending, false for descending
  FilterCart(this.sortBy, this.ascending);
}

class SelectCartItemsRequested extends CartEvent {
  final List<String> cartIds;
  SelectCartItemsRequested(this.cartIds);
}

class ChangePaymentMethod extends CartEvent {
  final String paymentMethod;
  ChangePaymentMethod(this.paymentMethod);
}

class CheckoutRequested extends CartEvent {
  final List<String> cartIds;
  final OrderModel order;

  CheckoutRequested(this.cartIds, this.order);
}

class PaymentExecuted extends CartEvent {
  final String paymentId;
  final String transactionId;
  final String amount;
  final String currency;
  final String invoiceNumber;

  final List<String> cartIds;
  final OrderModel order;

  PaymentExecuted(
      {required this.cartIds,
      required this.order,
      required this.paymentId,
      required this.transactionId,
      required this.amount,
      required this.currency,
      required this.invoiceNumber});
}

class CartCheckoutGotError extends CartEvent {
  final String message;
  CartCheckoutGotError(this.message);
}

class CartCheckoutShowLoading extends CartEvent {
  CartCheckoutShowLoading();
}
