import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/gender_cubit.dart';

class GenderPicker extends StatelessWidget {
  GenderPicker({
    super.key,
    required this.width,
    required this.height,
    required this.bgColor,
    required this.fgColor,
    required this.hasBorder,
    this.borderColor,
  });

  final double width;
  final double height;
  final Color bgColor;
  final Color fgColor;
  final bool hasBorder;
  final Color? borderColor;

  final List<String> _genders = ["Male", "Female", "Other"];

  @override
  Widget build(BuildContext context) {
    final genderCubit = context.watch<GenderCubit>();

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: hasBorder && borderColor != null
            ? Border.all(color: borderColor!, width: 2)
            : null,
      ),
      child: Center(
        child: DropdownButtonFormField<String>(
          dropdownColor: Colors.white,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
          ),
          value: genderCubit.state,
          onChanged: (String? newValue) {
            if (newValue != null) {
              genderCubit.selectGender(newValue);
            }
          },
          hint: Text(
            'Select your gender',
            style: TextStyle(color: fgColor),
          ),
          icon: Icon(
            Icons.arrow_drop_down,
            color: fgColor,
          ),
          items: _genders.map((String gender) {
            return DropdownMenuItem<String>(
              value: gender,
              child: Text(
                gender,
                style: TextStyle(color: fgColor),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
