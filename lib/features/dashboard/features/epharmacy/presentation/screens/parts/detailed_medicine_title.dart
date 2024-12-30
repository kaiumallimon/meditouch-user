
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../logics/detailed_medicine_state.dart';

Row detailedMedicineTitle(DetailedMedicineSuccess state, ColorScheme theme) {
  return Row(
    children: [
      Expanded(
        child: RichText(
          maxLines: 2,
          overflow: TextOverflow.ellipsis, // Prevent overflow with ellipsis
          text: TextSpan(
            children: [
              TextSpan(
                text: state.medicineDetails.medicineName,
                style: TextStyle(
                  fontFamily: 'SF-Pro-Text',
                  color: theme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: ' ', // Add space between the medicine name and strength
                style: TextStyle(
                  color:
                      theme.onSurface, // Maintain the same color for the space
                  fontSize: 18,
                ),
              ),
              TextSpan(
                text: state.medicineDetails.strength,
                style: TextStyle(
                  color: theme.onSurface.withOpacity(.5),
                  fontSize: 14,
                  fontFamily: 'SF-Pro-Text',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(width: 10),
      const Icon(
        Icons.verified,
        color: CupertinoColors.activeGreen,
        size: 20,
      ),
    ],
  );
}
