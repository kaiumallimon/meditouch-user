import 'package:flutter/material.dart';
import 'package:meditouch/app/app_exporter.dart';
import 'package:meditouch/features/dashboard/features/cart/logics/cart_bloc.dart';

import '../../../logics/cart_event.dart';
import '../../../logics/cart_state.dart';

AppBar checkoutAppBar(ColorScheme theme) {
  return AppBar(
    backgroundColor: theme.surfaceContainer,
    surfaceTintColor: theme.surfaceContainer,
    elevation: 0,
    toolbarHeight: 70,
    title: const Text('Checkout'),
    leading: BlocBuilder<CartBloc, CartState>(builder: (context, state) {
      return IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: !(state is CartCheckoutSuccess || state is CartPaymentSate)
            ? () {
                Navigator.pop(context);
                context.read<CartBloc>().add(LoadCart());
              }
            : null,
      );
    }),
  );
}
