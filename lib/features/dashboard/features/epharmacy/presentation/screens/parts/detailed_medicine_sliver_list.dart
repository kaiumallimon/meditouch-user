import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditouch/common/utils/epharmacy_util.dart';

import '../../../logics/detailed_medicine_state.dart';
import '../detailed_medicine.dart';
import 'detailed_medicine_alternative_title.dart';
import 'detailed_medicine_brand.dart';
import 'detailed_medicine_caution.dart';
import 'detailed_medicine_generic.dart';
import 'detailed_medicine_order_stats.dart';
import 'detailed_medicine_pricing.dart';
import 'detailed_medicine_title.dart';

SliverList BuildSliverList(
    BuildContext context, ColorScheme theme, DetailedMedicineSuccess state) {
  return SliverList(
      delegate: SliverChildListDelegate([
    Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: theme.primary.withOpacity(.03),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // order stats
          OrderStats(theme, state),

          const SizedBox(height: 20),

          // medicine name and strength
          detailedMedicineTitle(state, theme),

          const SizedBox(height: 20),

          // brand name
          detailedMedicineBrandName(theme, state),

          const SizedBox(height: 10),

          // generic
          detailedMedicineGeneric(theme, state),

          const SizedBox(height: 10),

          // divider
          Divider(
            color: theme.primary.withOpacity(.15),
            thickness: .6,
          ),

          const SizedBox(height: 10),

          // pricing unit and add to cart button
          detailedMedicinePricingCart(state, theme, context),

          const SizedBox(height: 40),

          // alternative medicines title
          detailedMedicineAlternativeTitle(theme, state),

          const SizedBox(height: 20),

          // alternative medicines list
          buildAlternativeMedicinesList(state, theme),

          const SizedBox(height: 40),

          // caution details
          detailedMedicineCautionDetails(
              state.medicineDetails.medicineDetails.medicineDetails, theme),
        ],
      ),
    )
  ]));
}

SizedBox buildAlternativeMedicinesList(
    DetailedMedicineSuccess state, ColorScheme theme) {
  return SizedBox(
    height: 240,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: state.medicineDetails.relatedMedicines.length,
      itemBuilder: (context, index) {
        var medicine = state.medicineDetails.relatedMedicines[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => DetailedMedicineScreen(
                  medicineName: medicine.medicineName,
                  strength: medicine.strength,
                  slug: medicine.slug,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(right: 10),
            width: 150,
            decoration: BoxDecoration(
                color: theme.primary.withOpacity(.05),
                borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // medicine image:
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: getImageUrl(medicine.medicineImage),
                          fit: BoxFit.cover,
                        ),

                        // discount
                        if (medicine.discountValue > 0)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              margin: const EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                  color: theme.primary.withOpacity(.1),
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(8))),
                              child: Text(
                                '${medicine.discountValue}% OFF',
                                style: TextStyle(
                                    color: theme.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // medicine name
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${medicine.medicineName} ${medicine.strength} ",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: theme.onSurface,
                        height: 1,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                ),

                // medicine brand name
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Text(
                    medicine.manufacturerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: theme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ),

                const SizedBox(height: 5),

                // medicine price
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    children: [
                      Text(
                        '৳ ${getDiscountedPrice(medicine.unitPrices.first.price, medicine).toStringAsFixed(2)}',
                        style: TextStyle(
                            color: theme.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
