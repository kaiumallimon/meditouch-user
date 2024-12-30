import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../../../../../common/utils/epharmacy_util.dart';
import '../../../../../../../common/widgets/custom_button.dart';
import '../../../logics/detailed_medicine_state.dart';
import 'detailed_medicine_price_unit_dropdown.dart';

Row detailedMedicinePricingCart(
    DetailedMedicineSuccess state, ColorScheme theme, BuildContext context) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            detailedMedicineUnitSelectorDropDown(state, theme, context),
            const SizedBox(height: 5),
            Text(
              '৳ ${(state.medicineDetails.unitPrices[state.selectedUnitIndex].price)}',
              style: TextStyle(
                  color: theme.onSurface.withOpacity(.5),
                  decoration: TextDecoration.lineThrough,
                  decorationColor: theme.onSurface.withOpacity(.5),
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  '৳ ${getDiscountedPriceByDiscountValue(double.parse(state.medicineDetails.unitPrices[state.selectedUnitIndex].price), state.medicineDetails.discountValue).toStringAsFixed(2)}',
                  style: TextStyle(
                      color: theme.primary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),

                // discount
                if (state.medicineDetails.discountValue > 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    margin: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        color: theme.primary.withOpacity(.1),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      '${state.medicineDetails.discountValue}% OFF',
                      style: TextStyle(
                          color: theme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      CustomButton(
          size: const Size(120, 35),
          textSize: 12,
          text: "Add To Cart",
          onPressed: () {
            QuickAlert.show(
              barrierDismissible: false,
              context: context,
              type: QuickAlertType.info,
              text: 'Yet to implement',
            );
          },
          bgColor: theme.primary,
          fgColor: theme.onPrimary,
          isLoading: false)
    ],
  );
}
