import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

SingleChildScrollView detailedMedicineShimmer(ColorScheme theme) {
    return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Shimmer.fromColors(
                    baseColor: theme.primary.withOpacity(0.4),
                    highlightColor: theme.secondary.withOpacity(0.6),
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Shimmer.fromColors(
                    baseColor: theme.primary.withOpacity(0.4),
                    highlightColor: theme.secondary.withOpacity(0.6),
                    child: Container(
                      height: 30,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Shimmer.fromColors(
                    baseColor: theme.primary.withOpacity(0.4),
                    highlightColor: theme.secondary.withOpacity(0.6),
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Shimmer.fromColors(
                    baseColor: theme.primary.withOpacity(0.4),
                    highlightColor: theme.secondary.withOpacity(0.6),
                    child: Container(
                      height: 20,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Shimmer.fromColors(
                    baseColor: theme.primary.withOpacity(0.4),
                    highlightColor: theme.secondary.withOpacity(0.6),
                    child: Container(
                      height: 20,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer.fromColors(
                            baseColor: theme.primary.withOpacity(0.4),
                            highlightColor: theme.secondary.withOpacity(0.6),
                            child: Container(
                              height: 40,
                              width: 80,
                              decoration: BoxDecoration(
                                color: theme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Shimmer.fromColors(
                            baseColor: theme.primary.withOpacity(0.4),
                            highlightColor: theme.secondary.withOpacity(0.6),
                            child: Container(
                              height: 30,
                              width: 100,
                              decoration: BoxDecoration(
                                color: theme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Shimmer.fromColors(
                        baseColor: theme.primary.withOpacity(0.4),
                        highlightColor: theme.secondary.withOpacity(0.6),
                        child: Container(
                          height: 45,
                          width: 120,
                          decoration: BoxDecoration(
                            color: theme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Shimmer.fromColors(
                    baseColor: theme.primary.withOpacity(0.4),
                    highlightColor: theme.secondary.withOpacity(0.6),
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            );
  }