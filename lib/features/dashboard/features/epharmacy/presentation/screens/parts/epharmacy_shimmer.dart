import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildEpharmacyShimmer(BuildContext context, ColorScheme theme) {
  return Column(
    children: [
      // First shimmer: Full-width container
      Shimmer.fromColors(
        baseColor: theme.primary.withOpacity(0.3),
        highlightColor: theme.secondary.withOpacity(0.5),
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      const SizedBox(height: 12),
      // Second shimmer: Smaller full-width container
      Shimmer.fromColors(
        baseColor: theme.primary.withOpacity(0.3),
        highlightColor: theme.secondary.withOpacity(0.5),
        child: Container(
          height: 20,
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      const SizedBox(height: 12),
      // Grid shimmer
      Flexible(
        fit: FlexFit.loose,
        child: GridView.builder(
          shrinkWrap: true, // Important to prevent infinite height error
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 6,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: 273,
          ),
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              direction: ShimmerDirection.ltr,
              baseColor: theme.primary.withOpacity(0.4),
              highlightColor: theme.secondary.withOpacity(0.4),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}
