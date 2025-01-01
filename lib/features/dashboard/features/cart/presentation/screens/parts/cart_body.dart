import 'package:flutter/material.dart';

import '../../../logics/cart_state.dart';
import '../../../models/cart_model.dart';
import 'cart_filter.dart';
import 'cart_items_card.dart';

Widget cartBody(BuildContext context, ColorScheme theme,
    List<CartModel> cartItems, CartLoaded state) {
  return state.cartItems.isEmpty
      ? Center(
          child: Text('No items in cart',
              style: TextStyle(
                  color: theme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.normal)),
        )
      : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CartFilterBar(theme: theme),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];

                    final bool isSelected =
                        state.selectedItems.contains(item.cartId);

                    return cartItemsCard(
                        isSelected, context, state, item, theme);
                  },
                ),
              ),
            ],
          ),
        );
}
