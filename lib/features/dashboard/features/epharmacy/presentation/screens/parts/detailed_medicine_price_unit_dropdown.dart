import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logics/detailed_medicine_bloc.dart';
import '../../../logics/detailed_medicine_event.dart';
import '../../../logics/detailed_medicine_state.dart';

DropdownButton<String> detailedMedicineUnitSelectorDropDown(
    DetailedMedicineSuccess state, ColorScheme theme, BuildContext context) {
  return DropdownButton<String>(
    value: state.medicineDetails.unitPrices[state.selectedUnitIndex].unit,
    icon: Icon(Icons.arrow_drop_down_rounded,
        color: theme.onSurface.withOpacity(.5)),
    iconSize: 24,
    elevation: 16,
    style: TextStyle(
        fontFamily: 'SF-Pro-Text',
        color: theme.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w500),
    underline: Container(
      height: 0,
      color: theme.primary,
    ),
    onChanged: (String? newValue) {
      context.read<DetailedMedicineBloc>().add(ChangeUnitRequested(state
          .medicineDetails.unitPrices
          .indexWhere((element) => element.unit == newValue)));
    },
    items: state.medicineDetails.unitPrices
        .map<DropdownMenuItem<String>>((unitPrice) {
      return DropdownMenuItem<String>(
        value: unitPrice.unit,
        child: Text("${unitPrice.unit.replaceAll('Ã', 'x')}"),
      );
    }).toList(),
  );
}
