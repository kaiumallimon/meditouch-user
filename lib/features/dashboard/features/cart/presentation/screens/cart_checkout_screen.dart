import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/common/widgets/custom_loading_animation.dart';
import 'package:meditouch/features/dashboard/features/cart/models/cart_model.dart';

import '../../logics/cart_bloc.dart';
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

          if (state is CartPaymentSate) {
            return Container();
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
