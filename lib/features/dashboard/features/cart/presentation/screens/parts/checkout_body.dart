import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../auth/register/presentation/widgets/custom_textfield_reg.dart';
import '../../../logics/cart_bloc.dart';
import '../../../models/cart_model.dart';
import 'checkout_button.dart';
import 'checkout_cart_view.dart';
import 'checkout_payment_method_selector.dart';

SingleChildScrollView checkoutBody(
    BuildContext context,
    ColorScheme theme,
    List<CartModel> cartItems,
    
    List<String> selectedItems) {
  return SingleChildScrollView(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    physics: const BouncingScrollPhysics(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Items selected:',
            style: TextStyle(
                color: theme.onSurface,
                fontSize: 15,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),

        // cart items
        checkoutCartItemsView(theme, cartItems),

        const SizedBox(height: 20),

        // delivery address
        Text('Delivery address:',
            style: TextStyle(
                color: theme.onSurface,
                fontSize: 15,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),

        BlocBuilder<AddressCubit, String>(
          builder: (context, state) {
            return CustomTextfield(
                hint: "Where should we deliver your order?",
                onChanged: (value) {
                  context.read<AddressCubit>().updateAddress(value);
                },
                size: const Size(500, 50),
                bgColor: theme.primary.withOpacity(.1),
                fgColor: theme.onSurface,
                controller: TextEditingController(text: state)
                  ..selection = TextSelection.fromPosition(
                    TextPosition(offset: state.length),
                  ),
                iconData: Icons.location_on);
          },
        ),

        const SizedBox(height: 20),

        // payment method radio buttons
        checkoutPaymentMethodSelector(theme),

        // checkout button
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 40),
          child: BlocBuilder<AddressCubit, String>(
            builder: (context, state) {
              return state.isNotEmpty
                  ? checkoutButton(
                      context, theme, cartItems, state, selectedItems)
                  : Container();
            },
          ),
        ),
      ],
    ),
  );
}

