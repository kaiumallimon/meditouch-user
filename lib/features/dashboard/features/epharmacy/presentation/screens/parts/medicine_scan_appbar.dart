import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logics/medicine_scan_bloc.dart';
import '../../../logics/medicine_scan_event.dart';

AppBar medicineScanAppbar(BuildContext context, ColorScheme theme) {
    return AppBar(
      backgroundColor: theme.surfaceContainer,
      elevation: 0,
      surfaceTintColor: theme.surfaceContainer,
      leading: IconButton(
          onPressed: () {
            context.read<MedicineScanBloc>().add(const ResetMedicineScan());
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back)),
      centerTitle: false,
      title: const Text(
        'Scan Medicine',
      ),
    );
  }