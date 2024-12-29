import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../../../common/utils/epharmacy_util.dart';
import '../../../data/model/medicine_model.dart';

Container BuildMedicineCard(ColorScheme theme, Medicine medicine,
    double unitPrice, String unit, double discountedPrice) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: theme.primary.withOpacity(.1), width: 2),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Medicine image
        Stack(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              child: CachedNetworkImage(
                imageUrl: getImageUrl(medicine.medicineImage),
                fit: BoxFit.cover,
                height: 150,
                width: double.infinity,
              ),
            ),
            // Discount badge
            if (medicine.discountValue > 0)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${medicine.discountValue.toStringAsFixed(0)}% OFF',
                    style: TextStyle(
                        color: theme.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
              ),
          ],
        ),

        // Medicine name
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${medicine.medicineName} ${medicine.strength}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, height: 1, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                // Manufacturer name
                Text(
                  medicine.manufacturerName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.primary.withOpacity(.5),
                  ),
                ),
                const Spacer(),
                // Price section: original price and discounted price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "৳${unitPrice.toStringAsFixed(1)}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.grey),
                    ),
                    // Discounted price
                    Text(
                      "৳${discountedPrice.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
