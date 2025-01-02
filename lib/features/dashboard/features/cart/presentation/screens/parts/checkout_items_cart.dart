import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../../../common/utils/epharmacy_util.dart';
import '../../../models/cart_model.dart';

Column checkoutItemsCard(
    CartModel item, ColorScheme theme, int index, List<CartModel> cartItems) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ListTile(
        leading: CircleAvatar(
          backgroundImage: item.medicine.medicineImage.isNotEmpty
              ? CachedNetworkImageProvider(
                  getImageUrl(item.medicine.medicineImage))
              : null,
          backgroundColor: Colors.transparent,
        ),
        title: Text(
          "${item.medicine.medicineName} ${item.medicine.strength}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: theme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        subtitle: Text(
          "Qty: ${item.quantity} (${item.medicine.unitPrices[item.unitIndex].unit.replaceAll('Ã', 'x')})",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: theme.onPrimary.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
        trailing: Text(
          "৳${item.discountedPrice.toStringAsFixed(2)}",
          style: TextStyle(
            color: theme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
      if (index != cartItems.length - 1)
        Divider(
          color: theme.onPrimary.withOpacity(.5),
          thickness: 0.5,
        ),
    ],
  );
}