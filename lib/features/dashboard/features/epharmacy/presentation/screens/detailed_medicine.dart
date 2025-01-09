import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/common/widgets/custom_loading_animation.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/logics/detailed_medicine_bloc.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/logics/detailed_medicine_event.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/logics/detailed_medicine_state.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shimmer/shimmer.dart';

import 'parts/detailed_medicine_sliver_appbar.dart';
import 'parts/detailed_medicine_sliver_list.dart';

class DetailedMedicineScreen extends StatelessWidget {
  const DetailedMedicineScreen({
    super.key,
    required this.medicineName,
    this.strength,
    required this.slug,
  });

  final String medicineName;
  final String? strength;
  final String slug;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    // Fetch data every time screen is rebuilt
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<DetailedMedicineBloc>()
          .add(FetchDetailedMedicineEvent(slug));
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.surfaceContainer,
        body: BlocConsumer<DetailedMedicineBloc, DetailedMedicineState>(
          builder: (context, state) {
            if (state is DetailedMedicineLoading) {
              // return CustomLoadingAnimation(size: 30, color: theme.primary);
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

            if (state is DetailedMedicineError) {
              return Center(child: Text(state.message));
            }

            if (state is DetailedMedicineSuccess) {
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  DetailedMedicineSliverAppBar(
                      theme, state, medicineName, strength),
                  const SliverToBoxAdapter(child: SizedBox(height: 8)),
                  BuildSliverList(context, theme, state),
                ],
              );
            }

            return const SizedBox.shrink();
          },
          listener: (context, state) {
            if (state is CartAddError) {
              QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  text: state.message,
                  onConfirmBtnTap: () {
                    context
                        .read<DetailedMedicineBloc>()
                        .add(FetchDetailedMedicineEvent(slug));
                    Navigator.pop(context);
                  },
                  barrierColor: theme.onSurface.withOpacity(.5));
            }

            if (state is AddToCartSuccess) {
              QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                  text: state.message,
                  onConfirmBtnTap: () {
                    context
                        .read<DetailedMedicineBloc>()
                        .add(FetchDetailedMedicineEvent(slug));
                    Navigator.pop(context);
                  },
                  barrierColor: theme.onSurface.withOpacity(.5));
            }
          },
        ),
      ),
    );
  }
}
