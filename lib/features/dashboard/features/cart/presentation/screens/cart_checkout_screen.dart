import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/common/repository/bkash_repository.dart';
import 'package:meditouch/common/widgets/custom_loading_animation.dart';
import 'package:meditouch/features/dashboard/features/cart/models/cart_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../../common/repository/hive_repository.dart';
import '../../../epharmacy/data/model/medicine_model.dart';
import '../../../order/data/models/order_model.dart';
import '../../logics/cart_bloc.dart';
import '../../logics/cart_event.dart';
import '../../logics/cart_state.dart';
import 'parts/checkout_appbar.dart';
import 'parts/checkout_body.dart';
import 'parts/checkout_success.dart';

class CartCheckoutScreen extends StatelessWidget {
  const CartCheckoutScreen(
      {super.key, required this.cartItems, required this.selectedItems});

  final List<CartModel> cartItems;
  final List<String> selectedItems;

  @override
  Widget build(BuildContext context) {
    // get theme
    final theme = Theme.of(context).colorScheme;

    return SafeArea(
        child: Scaffold(
      backgroundColor: theme.surfaceContainer,
      // appbar
      appBar: checkoutAppBar(theme),

      // body
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartCheckoutLoading) {
            return CustomLoadingAnimation(size: 30, color: theme.primary);
          }

          if (state is CartCheckoutSuccess) {
            return checkoutSuccess(theme, context);
          }

          if (state is CartPaymentWebview) {
            return checkoutWebView(
                theme, context, state, cartItems, selectedItems);
          }

          if (state is CartCheckoutError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: theme.error),
              ),
            );
          }

          return checkoutBody(context, theme, cartItems, selectedItems);
        },
      ),
    ));
  }
}

Widget checkoutWebView(
    ColorScheme theme,
    BuildContext context,
    CartPaymentWebview state,
    List<CartModel> cartItems,
    List<String> selectedItems) {
  return WebViewWidget(
    controller: WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) async {
            if (url.contains('success')) {
              print('Executing payment, please wait!');

              try {
                final response = await BkashRepository().executePaymentresponse(
                  idToken: state.tokenId,
                  paymentID: state.paymentId,
                );

                if (response.statusMessage == 'Successful') {
                  BlocProvider.of<CartBloc>(context).add(PaymentExecuted(
                      cartIds: selectedItems,
                      paymentId: state.paymentId,
                      transactionId: response.trxID,
                      amount: response.amount,
                      currency: response.currency,
                      invoiceNumber: response.merchantInvoiceNumber,
                      order: OrderModel(
                          medicines: state.medicines,
                          uid: state.uid,
                          orderStatus: 'Processing',
                          orderDate: DateTime.now(),
                          deliveryAddress: state.deliveryAddress,
                          userPhoneNumber: state.userPhone,
                          userFullName: state.userFullName,
                          paymentMethod: "bKash",
                          paymentStatus: response.amount == state.totalAmount
                              ? 'Paid'
                              : 'Pending',
                          totalPrice: state.totalAmount,
                          orderId: "")));
                } else {
                  BlocProvider.of<CartBloc>(context)
                      .add(CartCheckoutGotError(response.statusMessage));
                }
              } catch (e) {
                BlocProvider.of<CartBloc>(context)
                    .add(CartCheckoutGotError(e.toString()));
              }
            } else if (url.contains('failure')) {
              print('Payment failed');
              BlocProvider.of<CartBloc>(context)
                  .add(CartCheckoutGotError('Payment failed'));
            } else if (url.contains('cancelled')) {
              BlocProvider.of<CartBloc>(context)
                  .add(CartCheckoutGotError('Payment cancelled'));
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(state.paymentUrl)),
  );
}
