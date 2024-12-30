import 'package:flutter/material.dart';

import '../../../logics/detailed_medicine_state.dart';

RichText detailedMedicineAlternativeTitle(
    ColorScheme theme, DetailedMedicineSuccess state) {
  return RichText(
      text: TextSpan(children: [
    TextSpan(
      text: 'Alternatives to',
      style: TextStyle(
        color: theme.onSurface.withOpacity(.5),
        fontSize: 16,
        fontFamily: 'SF-Pro-Text',
        fontWeight: FontWeight.w600,
      ),
    ),

    // medicine name
    TextSpan(
      text:
          ' ${state.medicineDetails.medicineName} ${state.medicineDetails.strength}',
      style: TextStyle(
        color: theme.primary,
        fontSize: 16,
        fontFamily: 'SF-Pro-Text',
        fontWeight: FontWeight.w600,
      ),
    ),
  ]));
}