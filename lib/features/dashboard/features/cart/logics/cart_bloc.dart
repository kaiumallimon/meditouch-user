// cart_bloc.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/app/app_exporter.dart';

import '../data/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import 'package:meditouch/features/dashboard/features/cart/models/cart_model.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  CartBloc(this.cartRepository) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<FilterCart>(_onFilterCart);
    on<SelectCartItemsRequested>(_onSelectCartItemsRequested);
  }

  FutureOr<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final userInfo = await HiveRepository().getUserInfo();

      final uid = userInfo!['id'];
      final cartItems = await cartRepository.getCartList(uid);
      emit(CartLoaded(cartItems));
    } catch (e) {
      emit(CartError('Failed to load cart: ${e.toString()}'));
    }
  }

  FutureOr<void> _onRemoveFromCart(
      RemoveFromCart event, Emitter<CartState> emit) async {
    final currentState = state as CartLoaded;
    try {
      List<String> cartIds = event.cartIds;
      for (var cartId in cartIds) {
        await cartRepository.removeFromCart(cartId);
      }

      List<CartModel> updatedCartItems = List.from(currentState.cartItems)
          .where((element) => !cartIds.contains(element.cartId))
          .toList()
          .cast<CartModel>();

      emit(CartLoaded(updatedCartItems));
    } catch (e) {
      emit(CartError('Failed to remove item from cart: ${e.toString()}'));
    }
  }

  FutureOr<void> _onFilterCart(FilterCart event, Emitter<CartState> emit) {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      List<CartModel> filteredItems = List.from(currentState.cartItems);

      if (event.sortBy == "createdAt") {
        filteredItems.sort((a, b) => event.ascending
            ? a.createdAt.compareTo(b.createdAt)
            : b.createdAt.compareTo(a.createdAt));
      } else if (event.sortBy == "totalPrice") {
        filteredItems.sort((a, b) => event.ascending
            ? a.totalPrice.compareTo(b.totalPrice)
            : b.totalPrice.compareTo(a.totalPrice));
      }

      emit(CartLoaded(filteredItems));
    }
  }

  FutureOr<void> _onSelectCartItemsRequested(
      SelectCartItemsRequested event, Emitter<CartState> emit) {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      emit(CartLoaded(currentState.cartItems, selectedItems: event.cartIds));
    }
  }
}
