// cart_state.dart
import 'package:equatable/equatable.dart';
import 'package:meditouch/features/dashboard/features/cart/models/cart_model.dart';

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
