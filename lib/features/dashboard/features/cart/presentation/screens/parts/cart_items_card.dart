import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../common/utils/epharmacy_util.dart';
import '../../../logics/cart_bloc.dart';
import '../../../logics/cart_event.dart';
import '../../../logics/cart_state.dart';
import '../../../models/cart_model.dart';

GestureDetector cartItemsCard(bool isSelected, BuildContext context,
    CartLoaded state, CartModel item, ColorScheme theme) {
  return GestureDetector(
    onTap: () {
      if (isSelected) {
        context.read<CartBloc>().add(
              SelectCartItemsRequested(state.selectedItems
                  .where((element) => element != item.cartId)
                  .toList()),
            );
      } else {
        context.read<CartBloc>().add(
              SelectCartItemsRequested(state.selectedItems + [item.cartId]),
            );
      }
    },
    child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: isSelected ? theme.primary : theme.primaryContainer,
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(1000),
              child: CachedNetworkImage(
                imageUrl: getImageUrl(item.medicine.medicineImage),
                width: 70,
                height: 70,
                fadeInCurve: Curves.easeIn,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "${item.medicine.medicineName} ${item.medicine.strength}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: isSelected ? theme.onPrimary : theme.primary,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(
                      'Quantity: ${item.quantity} (${item.medicine.unitPrices[item.unitIndex].unit.replaceAll('Ã', 'x')})',
                      style: TextStyle(
                        color: isSelected ? theme.onPrimary : theme.primary,
                      )),
                  const SizedBox(height: 5),
                  Text('Price:  ৳${item.discountedPrice} ',
                      style: TextStyle(
                        color: isSelected ? theme.onPrimary : theme.primary,
                      )),
                ],
              ),
            )
          ],
        )),
  );
}
