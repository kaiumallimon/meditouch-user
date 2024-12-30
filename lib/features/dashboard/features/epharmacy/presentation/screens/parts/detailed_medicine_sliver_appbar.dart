import 'package:flutter/material.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/presentation/screens/parts/detailed_medicine_image.dart';

import '../../../logics/detailed_medicine_state.dart';

SliverAppBar DetailedMedicineSliverAppBar(ColorScheme theme,
    DetailedMedicineSuccess state, String medicineName, String? strength) {
  return SliverAppBar(
    title: Text("$medicineName ${strength ?? ''}",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: theme.primary)),
    backgroundColor: theme.surfaceContainer,
    expandedHeight: 300,
    elevation: 0,
    floating: true,
    surfaceTintColor: theme.surfaceContainer,
    pinned: true,
    flexibleSpace: FlexibleSpaceBar(
      background: BuildDetailedMedicineImage(state),
    ),
  );
}
