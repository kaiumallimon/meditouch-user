import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meditouch/common/utils/epharmacy_util.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/presentation/screens/detailed_medicine.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/presentation/screens/parts/search_not_found.dart';

import '../../../logics/epharmacy_search_state.dart';

Padding buildSearchResults(EpharmacySearchSuccess state, ColorScheme theme) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Show the query that the user searched for
        Text(
          'Showing ${state.medicines.length} results for: ${state.query}',
          style: TextStyle(
            color: theme.onSurface.withOpacity(0.6),
          ),
        ),

        // space
        const SizedBox(height: 10),

        // Show the list of medicines
        Expanded(
          child: state.medicines.isEmpty
              ? const Center(
                  child: SearchNotFound(width: 200, height: 200),
                )
              : ListView.builder(
                  itemCount: state.medicines.length,
                  itemBuilder: (context, index) {
                    final medicine = state.medicines[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigate to the medicine details screen
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DetailedMedicineScreen(
                              medicineName: medicine.medicineName,
                              slug: medicine.slug,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        height: 90,
                        decoration: BoxDecoration(
                          color: theme.primary.withOpacity(.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(10),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: getImageUrl(medicine.medicineImage),
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, right: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${medicine.medicineName} ${medicine.strength}",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        height: 1.2,
                                        color: theme.onSurface,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      medicine.manufacturerName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        height: 1,
                                        fontSize: 12,
                                        color: theme.primary.withOpacity(0.8),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      medicine.genericName,
                                      style: TextStyle(
                                          height: 1,
                                          color: theme.secondary,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    ),
  );
}
