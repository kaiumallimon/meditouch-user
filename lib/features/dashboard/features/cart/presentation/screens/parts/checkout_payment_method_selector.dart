import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logics/cart_bloc.dart';

BlocBuilder<PaymentCubit, String> checkoutPaymentMethodSelector(ColorScheme theme) {
  return BlocBuilder<PaymentCubit, String>(builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Payment method:',
                style: TextStyle(
                    color: theme.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Row(
              children: [
                Radio(
                  value: 'cod',
                  groupValue: state,
                  onChanged: (value) {
                    BlocProvider.of<PaymentCubit>(context)
                        .changePaymentMethod(value.toString());
                  },
                ),
                Text('Cash on delivery',
                    style: TextStyle(
                        color: theme.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
              ],
            ),
            Row(
              children: [
                Radio(
                  value: 'bkash',
                  groupValue: state,
                  onChanged: (value) {
                    BlocProvider.of<PaymentCubit>(context)
                        .changePaymentMethod(value.toString());
                  },
                ),
                Text('Bkash',
                    style: TextStyle(
                        color: theme.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        );
      });
}