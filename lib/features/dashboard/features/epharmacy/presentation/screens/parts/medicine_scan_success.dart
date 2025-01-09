import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../common/widgets/custom_button.dart';
import '../../../logics/medicine_scan_bloc.dart';
import '../../../logics/medicine_scan_event.dart';
import '../../../logics/medicine_scan_state.dart';

Column medicineScanSuccess(
      ColorScheme theme, MedicineScanSuccess state, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.primaryContainer,
            border: Border.all(color: theme.primaryContainer, width: 2),
          ),
          child: Image.file(
            File(state.image.path),
            fit: BoxFit.cover,
            height: 250,
            width: 250,
          ),
        ),

        const SizedBox(height: 20),

        // continue button
        CustomButton(
            size: Size(120, 45),
            text: "Continue",
            onPressed: () {
              context.read<MedicineScanBloc>().add(SendGeminiRequested(state
                  .image)); // Dispatch the event to send the image to Gemini
            },
            bgColor: theme.primary,
            fgColor: theme.onPrimary,
            isLoading: false)
      ],
    );
  }