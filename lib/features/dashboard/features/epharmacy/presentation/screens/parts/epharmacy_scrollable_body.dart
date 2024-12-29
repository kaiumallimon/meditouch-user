import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';

import '../../../../../../../common/utils/epharmacy_util.dart';
import '../../../logics/epharmacy_bloc.dart';
import '../../../logics/epharmacy_events.dart';
import '../../../logics/epharmacy_states.dart';
import 'epharmacy_medicine_card.dart';
import 'epharmacy_searchbar.dart';

class EpharmacyScrollableBody extends StatelessWidget {
  final ColorScheme theme;

  const EpharmacyScrollableBody({required this.theme, super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return BlocConsumer<EpharmacyBloc, EpharmacyStates>(
      listener: (context, state) {
        if (state is EpharmacyErrorState) {
          // Show error alert
          QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              text: state.message);
        }
      },
      builder: (context, state) {
        if (state is EpharmacyLoadingState) {
          return Center(
            child: CupertinoActivityIndicator(radius: 12, color: theme.primary),
          );
        }

        if (state is EpharmacySuccessState) {
          return CustomScrollView(
            controller: scrollController
              ..addListener(() {
                if (scrollController.position.atEdge &&
                    scrollController.position.pixels != 0) {
                  context
                      .read<EpharmacyBloc>()
                      .add(EpharmacyLoadMoreEvent(getNextPage(state)));
                }
              }),
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Search Bar
              buildSearchBar(context, theme),

              // Space
              const SliverToBoxAdapter(child: SizedBox(height: 10)),

              // Medicines Grid
              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final medicine = state.medicines[index];
                    return BuildMedicineCard(
                      theme,
                      medicine,
                      getUnitPrice(medicine),
                      getUnit(medicine),
                      getDiscountedPrice(getUnitPrice(medicine), medicine),
                    );
                  },
                  childCount: state.medicines.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: .68,
                ),
              ),

              // Loading Indicator for more data
              if (state.medicines.length < state.totalPages)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: CupertinoActivityIndicator(
                          radius: 12, color: theme.primary),
                    ),
                  ),
                ),
            ],
          );
        }

        if (state is EpharmacyErrorState) {
          return Center(child: Text(state.message));
        }

        return const SizedBox();
      },
    );
  }
}
