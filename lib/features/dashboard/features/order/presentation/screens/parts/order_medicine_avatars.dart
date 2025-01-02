import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../../../common/utils/epharmacy_util.dart';
import '../../../../epharmacy/data/model/medicine_model.dart';

Widget medicineAvatars(List<Medicine> medicines) {
  const int maxVisible = 2;
  final displayedMedicines = medicines.take(maxVisible).toList();
  final remainingCount = medicines.length - maxVisible;

  return SizedBox(
    width: 20 + (displayedMedicines.length * 25.0), // Adjust width dynamically
    height: 40, // Fixed height for consistent alignment
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        // Display the limited number of medicines
        for (int i = 0; i < displayedMedicines.length; i++)
          Positioned(
            left: i * 18.0, // Overlap avatars slightly
            child: CircleAvatar(
              radius: 20,
              backgroundImage: CachedNetworkImageProvider(
                getImageUrl(displayedMedicines[i].medicineImage),
              ),
            ),
          ),
        // Display the "+X" if there are more medicines
        if (remainingCount > 0)
          Positioned(
            left: displayedMedicines.length * 18.0,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey.shade300,
              child: Text(
                '+$remainingCount',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

