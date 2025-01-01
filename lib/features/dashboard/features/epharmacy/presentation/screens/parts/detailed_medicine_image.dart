// ignore: non_constant_identifier_names
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../../../common/utils/epharmacy_util.dart';
import '../../../logics/detailed_medicine_state.dart';

Widget BuildDetailedMedicineImage(DetailedMedicineSuccess state) {
  return AspectRatio(
    aspectRatio: 16 / 9,
    child: (state.medicineDetails.medicineImage == null ||
            state.medicineDetails.medicineImage.isEmpty)
        ? Image.asset(
            'assets/images/medicine_placeholder.png',
            fit: BoxFit.cover,
          )
        : CachedNetworkImage(
            imageUrl: getImageUrl(state.medicineDetails.medicineImage),
            width: double.infinity,
            fit: BoxFit.cover,
          ),
  );
}
