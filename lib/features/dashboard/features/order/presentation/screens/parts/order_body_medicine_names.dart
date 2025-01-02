import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../logics/order_state.dart';

Column ordersBodyMedicineNames(
    OrderLoaded state, int index, ColorScheme theme) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
          child: Text(
            state.orders[index].medicines.length > 1
                ? '${state.orders[index].medicines[0].medicineName} and ${state.orders[index].medicines.length - 1} others'
                : state.orders[index].medicines[0].medicineName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: theme.primary, fontWeight: FontWeight.bold),
          )),

      // order status
      Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8, top: 2),
        child: Text(
          state.orders[index].orderStatus,
          style: TextStyle(
              color: theme.onSurface.withOpacity(.5),
              fontWeight: FontWeight.bold),
        ),
      ),

      // total price
      Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8, top: 2),
        child: Text(
          'Total: ${state.orders[index].totalPrice} (${state.orders[index].paymentMethod == 'bKash' ? 'Paid' : "COD"})',
          style: TextStyle(
              color: theme.onSurface.withOpacity(.5),
              fontWeight: FontWeight.bold),
        ),
      ),

      // order date
      Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8, top: 2),
        child: Text(
          'Ordered on: ${formatDateTimetoString(state.orders[index].orderDate)}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: theme.onSurface.withOpacity(.5),
              fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );
}

String formatDateTimetoString(DateTime dateTime) {
  // use intl
  // 12.30 PM, 12th June 2021

  final String formattedDate = DateFormat('dd MMM yy').format(dateTime);
  final String formattedTime = DateFormat('hh:mm a').format(dateTime);

  return '$formattedTime, $formattedDate';
}
