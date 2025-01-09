import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/common/widgets/custom_button.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/logics/epharmacy_events.dart';
import 'package:quickalert/quickalert.dart';
import '../../../logics/epharmacy_bloc.dart';
import '../../../logics/epharmacy_states.dart';
import '../detailed_medicine.dart';
import '../epharmacy_search.dart';
import 'epharmacy_medicine_card.dart';
import 'epharmacy_shimmer.dart';

Widget buildCustomBody(BuildContext context, ColorScheme theme) {
  return BlocConsumer<EpharmacyBloc, EpharmacyStates>(
    listener: (context, state) {
      if (state is EpharmacyErrorState) {
        QuickAlert.show(
            context: context, type: QuickAlertType.error, text: state.message);
      }
    },
    builder: (context, state) {
      // loading state
      if (state is EpharmacyLoadingState) {
        // return CustomLoadingAnimation(size: 30, color: theme.primary);
        return buildEpharmacyShimmer(context, theme);
      }

      // loaded state
      if (state is EpharmacySuccessState) {
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Search Bar
            buildSearchBar(context, theme),

            //space
            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            SliverToBoxAdapter(
                child: Text(
              'Showing ${state.currentPage} of ${state.totalPages} Pages',
              style: TextStyle(
                  color: theme.onSurface, fontWeight: FontWeight.normal),
            )),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // Grid View
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final medicine = state.medicines[index];

                  // Select the price based on the unit size (e.g., first unit size)
                  final unitPrice = medicine.unitPrices.isNotEmpty
                      ? medicine.unitPrices.first.price
                      : 0.0;
                  final String unit = medicine.unitPrices.isNotEmpty
                      ? medicine.unitPrices.first.unit
                      : '';

                  // Calculate the discounted price if applicable
                  final discountedPrice =
                      unitPrice - (unitPrice * (medicine.discountValue / 100));

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailedMedicineScreen(
                                    medicineName: medicine.medicineName,
                                    strength: medicine.strength,
                                    slug: medicine.slug,
                                    key: ValueKey(medicine.slug),
                                  )));
                    },
                    child: BuildMedicineCard(
                      theme,
                      medicine,
                      unitPrice,
                      unit,
                      discountedPrice,
                    ),
                  );
                },
                childCount: state.medicines.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 273,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Next Page Button
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                      size: const Size(120, 35),
                      text: "Previous",
                      onPressed: state.currentPage > 1
                          ? () {
                              context
                                  .read<EpharmacyBloc>()
                                  .add(EpharmacyRefreshEvent(
                                    currentPage: state.currentPage - 1,
                                  ));
                            }
                          : null,
                      bgColor: Colors.grey,
                      fgColor: Colors.white,
                      isLoading: false),
                  const SizedBox(width: 10),
                  CustomButton(
                      size: const Size(120, 35),
                      text: "Next",
                      onPressed: () {
                        context.read<EpharmacyBloc>().add(EpharmacyRefreshEvent(
                              currentPage: state.currentPage + 1,
                            ));
                      },
                      bgColor: theme.primary,
                      fgColor: theme.onPrimary,
                      isLoading: false),
                ],
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        );
      }

      // error state
      if (state is EpharmacyErrorState) {
        return Center(
          child: Text(state.message),
        );
      }

      // return empty container
      return const SizedBox();
    },
  );
}

Widget buildSearchBar(BuildContext context, ColorScheme theme) {
  return SliverToBoxAdapter(
    child: InkWell(
      splashColor: theme.primary.withOpacity(.1),
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => EpharmacySearchScreen()));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: theme.primary.withOpacity(.1), width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: theme.primary.withOpacity(.5),
            ),
            const SizedBox(width: 10),
            Text(
              'Search for medicines',
              style: TextStyle(
                  color: theme.primary.withOpacity(.5),
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    ),
  );
}
