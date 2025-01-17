import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/common/widgets/custom_loading_animation.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/logics/medicine_scan_bloc.dart';
import '../../logics/medicine_scan_state.dart';
import 'parts/default_scan_body.dart';
import 'parts/medicine_scan_appbar.dart';
import 'parts/medicine_scan_failure.dart';
import 'parts/medicine_scan_success.dart';
import 'scanned_medicine_list.dart';

class GeminiMedicineScan extends StatelessWidget {
  const GeminiMedicineScan({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the theme
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.surfaceContainer,
      appBar: medicineScanAppbar(context, theme),
      body: SafeArea(child: geminiMedicineScanBody(context, theme)),
    );
  }

  Center geminiMedicineScanBody(BuildContext context, ColorScheme theme) {
    return Center(
      child: BlocBuilder<MedicineScanBloc, MedicineScanState>(
        builder: (context, state) {
          if (state is MedicineScanLoading) {
            return CustomLoadingAnimation(
              size: 25,
              color: theme.primary,
            );
          }

          if (state is MedicineScanSuccess) {
            return medicineScanSuccess(theme, state, context);
          }

          if (state is MedicineScanFailure) {
            return medicineScanFailure(context, theme, "Something went wrong");
          }

          if (state is ScanResult) {
            return scannedMedicineList(state, theme);
          }

          return defaultScanScreen(context, theme);
        },
      ),
    );
  }
}
