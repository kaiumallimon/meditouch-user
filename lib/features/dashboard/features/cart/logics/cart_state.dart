// cart_state.dart
import 'package:meditouch/features/dashboard/features/cart/models/cart_model.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartModel> cartItems;
  final List<String> selectedItems;

  CartLoaded(this.cartItems, {this.selectedItems = const []});
}

class CartError extends CartState {
  final String message;
  CartError(this.message);
}
