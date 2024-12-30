import 'package:flutter/material.dart';

import '../../../logics/detailed_medicine_state.dart';

Container OrderStats(ColorScheme theme, DetailedMedicineSuccess state) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
        color: theme.primary.withOpacity(.05),
        borderRadius: BorderRadius.circular(8)),
    child: Row(
      children: [
        Image.asset(
          'assets/icons/icons8-stock-48.png',
          height: 18,
          width: 18,
          color: theme.primary,
        ),
        const SizedBox(width: 10),
        Text(
          '${state.medicineDetails.orderCount} units ordered',
          style: TextStyle(
              color: theme.onSurface,
              fontSize: 13,
              fontWeight: FontWeight.w500),
        )
      ],
    ),
  );
}
