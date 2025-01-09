import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logics/medicine_scan_bloc.dart';
import '../../../logics/medicine_scan_event.dart';

Column defaultScanScreen(BuildContext context, ColorScheme theme) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      GestureDetector(
        onTap: () => openModalSheet(context, theme),
        child: Container(
          decoration: BoxDecoration(
            color: theme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(30),
          child: Icon(
            Icons.camera_alt_rounded,
            size: 80,
            color: theme.primary,
          ),
        ),
      ),
      const SizedBox(height: 20),
      Text('Click on the camera\nicon to scan the medicine',
          textAlign: TextAlign.center,
          style: TextStyle(color: theme.onSurface)),
    ],
  );
}

void openModalSheet(BuildContext context, ColorScheme theme) {
  List<Map<String, dynamic>> options = [
    {
      'icon': Icon(Icons.camera_alt_rounded, color: theme.primary),
      'title': const Text('Scan Medicine'),
      'onTap': () {
        // Dispatch the event for scanning medicine
        context.read<MedicineScanBloc>().add(ScanMedicineRequested());
        Navigator.pop(
            context); // Close the bottom sheet after selecting the option
      },
    },
    {
      'icon': Icon(Icons.image, color: theme.primary),
      'title': const Text('Choose from Gallery'),
      'onTap': () {
        // Dispatch the event for selecting from the gallery
        context.read<MedicineScanBloc>().add(ChooseFromGalleryRequested());
        Navigator.pop(
            context); // Close the bottom sheet after selecting the option
      },
    },
  ];

  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        height: 200,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.surfaceContainer,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: options
              .map((option) => GestureDetector(
                    onTap: () => option['onTap'](),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: theme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: option['icon'],
                        title: option['title'],
                      ),
                    ),
                  ))
              .toList(),
        ),
      );
    },
  );
}
