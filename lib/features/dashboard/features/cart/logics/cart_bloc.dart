// cart_bloc.dart
import 'dart:async';
import 'package:meditouch/app/app_exporter.dart';
import 'package:meditouch/common/repository/bkash_repository.dart';
import 'package:meditouch/common/utils/invoice.dart';
import 'package:meditouch/features/dashboard/features/order/data/repository/order_repository.dart';

import '../data/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import 'package:meditouch/features/dashboard/features/cart/models/cart_model.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  CartBloc(this.cartRepository) : super(const CartInitial()) {
    // load the cart items on page openning
    on<LoadCart>(_onLoadCart);

    // remove the selected items from the cart
    on<RemoveFromCart>(_onRemoveFromCart);

    // filter the cart items based on the selected filter
    on<FilterCart>(_onFilterCart);

    // select the cart items to be checked out or removed
    on<SelectCartItemsRequested>(_onSelectCartItemsRequested);

    // change the payment method
    on<CheckoutRequested>(_onCheckoutRequested);

    // handle the payment execution
    on<PaymentExecuted>(_onPaymentExecuted);

    // handle the checkout error
    on<CartCheckoutGotError>(_onCartCheckoutGotError);
  }

  // Handle the checkout error

  FutureOr<void> _onCartCheckoutGotError(
      CartCheckoutGotError event, Emitter<CartState> emit) {
    emit(CartCheckoutError(event.message));
  }

  // Handle the payment execution
  FutureOr<void> _onPaymentExecuted(
      PaymentExecuted event, Emitter<CartState> emit) async {
    // initially show the loading state
    emit(const CartCheckoutLoading());

    // prepare the order
    final Map<String, dynamic> response =
        await OrderRepository().createOrder(event.order);

    // get the order id
    final String orderId = response['orderId'];

    if (response['status']) {
      // remove the items from the cart
      final removeResponse =
          await cartRepository.removeMultipleFromCart(event.cartIds);

      if (removeResponse['status']) {
        // add payment logs
        final paymentLogResponse = await OrderRepository().addPaymentLog(
            paymentId: event.paymentId,
            transactionId: event.transactionId,
            amount: double.parse(event.amount),
            currency: event.currency,
            invoiceNumber: event.invoiceNumber,
            orderId: orderId,
            userId: event.order.uid);

        if (paymentLogResponse['status']) {
          // emit the success state
          emit(const CartCheckoutSuccess());
        } else {
          // emit the error state
          emit(CartCheckoutError(paymentLogResponse['message']));
        }
      } else {
        // emit the error state
        emit(CartCheckoutError(removeResponse['message']));
      }
    } else {
      // emit the error state
      emit(CartCheckoutError(response['message']));
    }
  }

  // Handle the checkout request
  FutureOr<void> _onCheckoutRequested(
      CheckoutRequested event, Emitter<CartState> emit) async {
    emit(const CartCheckoutLoading());

    // check the payment method
    final String paymentMethod = event.order.paymentMethod;

    if (paymentMethod == 'bkash') {
      // grant the token
      await BkashRepository().grantToken().then((grantTokenResponse) async {
        if (grantTokenResponse.statusMessage != 'Successful') {
          // handle the error for token grant failure
          emit(CartCheckoutError(
              'Failed to grant token: ${grantTokenResponse.statusMessage}'));
          return;
        }

        // create payment:

        // for testing, the amount is fixed to 1

        final createPaymentResponse = await BkashRepository().createPayment(
            idToken: grantTokenResponse.idToken,
            amount: '1',
            invoiceNumber: generateInvoice());

        // check if the payment creation is successful

        if (createPaymentResponse.statusMessage != "Successful") {
          // handle the error for payment creation failure
          emit(CartCheckoutError(
              'Failed to create payment: ${createPaymentResponse.statusMessage}'));
          return;
        }

        // load the payment gateway
        emit(CartPaymentWebview(
            deliveryAddress: event.order.deliveryAddress,
            paymentId: createPaymentResponse.paymentID,
            paymentUrl: createPaymentResponse.bkashURL,
            tokenId: grantTokenResponse.idToken,
            uid: event.order.uid,
            totalAmount: event.order.totalPrice,
            userFullName: event.order.userFullName,
            userPhone: event.order.userPhoneNumber,
            medicines: event.order.medicines));
      });

      return;
    }

    // prepare the order
    final Map<String, dynamic> response =
        await OrderRepository().createOrder(event.order);

    if (response['status']) {
      // remove the items from the cart
      final removeResponse =
          await cartRepository.removeMultipleFromCart(event.cartIds);

      if (removeResponse['status']) {
        // emit the success state
        emit(const CartCheckoutSuccess());
      } else {
        // emit the error state
        emit(CartCheckoutError(removeResponse['message']));
      }
    } else {
      // emit the error state
      emit(CartCheckoutError(response['message']));
    }
  }

  // Load the cart items from the repository
  FutureOr<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    try {
      final userInfo = await HiveRepository().getUserInfo();

      final uid = userInfo!['id'];
      final cartItems = await cartRepository.getCartList(uid);
      emit(CartLoaded(cartItems));
    } catch (e) {
      emit(CartError('Failed to load cart: ${e.toString()}'));
    }
  }

  // Remove the selected items from the cart
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

  // Filter the cart items based on the selected filter
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

  // Select the cart items to be checked out or removed
  FutureOr<void> _onSelectCartItemsRequested(
      SelectCartItemsRequested event, Emitter<CartState> emit) {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      emit(CartLoaded(currentState.cartItems, selectedItems: event.cartIds));
    }
  }
}

// Payment cubit to manage the payment method state
class PaymentCubit extends Cubit<String> {
  PaymentCubit() : super('cod');

  void changePaymentMethod(String paymentMethod) {
    emit(paymentMethod);
  }
}

// Address cubit to manage the user address state for delivery
class AddressCubit extends Cubit<String> {
  AddressCubit() : super('');

  // update the address
  void updateAddress(String address) => emit(address);

  // clear the address
  void clearAddress() => emit('');
}
