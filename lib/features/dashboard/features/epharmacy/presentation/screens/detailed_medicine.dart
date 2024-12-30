import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/logics/detailed_medicine_bloc.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/logics/detailed_medicine_event.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/logics/detailed_medicine_state.dart';

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
        body: BlocBuilder<DetailedMedicineBloc, DetailedMedicineState>(
          builder: (context, state) {
            if (state is DetailedMedicineLoading) {
              return Center(
                child: CupertinoActivityIndicator(
                  color: theme.primary,
                  radius: 12,
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
        ),
      ),
    );
  }
}
