import 'package:flutter/material.dart';

import '../../../logics/detailed_medicine_state.dart';

RichText detailedMedicineBrandName(
    ColorScheme theme, DetailedMedicineSuccess state) {
  return RichText(
      text: TextSpan(children: [
    TextSpan(
      text: 'Brand: ',
      style: TextStyle(
        color: theme.onSurface,
        fontSize: 14,
        fontFamily: 'SF-Pro-Text',
        fontWeight: FontWeight.bold,
      ),
    ),
    TextSpan(
      text: state.medicineDetails.manufacturerName,
      style: TextStyle(
        color: theme.primary,
        fontSize: 14,
        fontFamily: 'SF-Pro-Text',
        fontWeight: FontWeight.w400,
      ),
    ),
  ]));
}

