import 'package:flutter/material.dart';
import 'package:meditouch/common/widgets/custom_tinted_iconbutton.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/presentation/screens/gemini_medicine_scan.dart';

import '../gemini_medicine_scan.dart';
import 'epharmacy_medicine_scan_button.dart';

Widget buildCustomAppBar(BuildContext context, ColorScheme theme) {
  return Padding(
    padding: const EdgeInsets.only(top: 0, bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('E-Pharmacy',
                style: TextStyle(
                    height: 1,
                    color: theme.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text('Powered by MedEasy',
                style: TextStyle(
                    color: theme.onSurface.withOpacity(.5), fontSize: 12)),
          ],
        ),

        
        buildGeminiMedicineScan(context, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const GeminiMedicineScan();
          }));
        }),

      ],
    ),
  );
}
