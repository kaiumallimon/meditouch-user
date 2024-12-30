import 'package:flutter/material.dart';

import '../../../logics/detailed_medicine_state.dart';

RichText detailedMedicineGeneric(
    ColorScheme theme, DetailedMedicineSuccess state) {
  return RichText(
      text: TextSpan(children: [
    TextSpan(
      text: 'Generic: ',
      style: TextStyle(
        color: theme.onSurface,
        fontSize: 14,
        fontFamily: 'SF-Pro-Text',
        fontWeight: FontWeight.bold,
      ),
    ),
    TextSpan(
      text: state.medicineDetails.genericName,
      style: TextStyle(
        color: theme.primary,
        fontSize: 14,
        fontFamily: 'SF-Pro-Text',
        fontWeight: FontWeight.w400,
      ),
    ),
  ]));
}

