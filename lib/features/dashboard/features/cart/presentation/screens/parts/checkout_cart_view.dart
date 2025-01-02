import 'package:flutter/material.dart';

import '../../../models/cart_model.dart';
import 'checkout_items_cart.dart';

Container checkoutCartItemsView(ColorScheme theme, List<CartModel> cartItems) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: theme.primary,
      borderRadius: BorderRadius.circular(13),
    ),
    child: Column(
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
            final item = cartItems[index];
            return checkoutItemsCard(item, theme, index, cartItems);
          },
        ),

        // Total price
        const SizedBox(height: 10),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Medicine',
                style: TextStyle(
                  color: theme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Text(
                "৳${calculateTotalPrice(cartItems).toStringAsFixed(2)}",
                style: TextStyle(
                  color: theme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery Charge',
                style: TextStyle(
                  color: theme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Text(
                "৳${calculateTotalPrice(cartItems) > 500 ? 0 : 50}",
                style: TextStyle(
                  color: theme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),

        // divider
        Divider(
          color: theme.onPrimary.withOpacity(.5),
          thickness: 1,
        ),

        // Total price

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  color: theme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                "৳${calculateTotalPrice(cartItems) > 500 ? calculateTotalPrice(cartItems).toDouble().toStringAsFixed(2) : (calculateTotalPrice(cartItems) + 50).toDouble().toStringAsFixed(2)}",
                style: TextStyle(
                  color: theme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('(Free delivery on orders over ৳500)',
                style: TextStyle(
                  color: theme.onPrimary.withOpacity(.6),
                  fontSize: 12,
                )),
          ],
        ),
      ],
    ),
  );
}

double calculateTotalPrice(List<CartModel> cartItems) {
  return cartItems.fold(
      0, (previousValue, element) => previousValue + element.discountedPrice);
}
