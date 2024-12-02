import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/date_cubit.dart';

class CustomDatePicker extends StatelessWidget {
  const CustomDatePicker({
    super.key,
    required this.label,
    required this.width,
    required this.height,
    required this.bgColor,
    required this.fgColor,
    required this.hasBorder,
    this.borderColor,
  });

  final String label;
  final double width;
  final double height;
  final Color bgColor;
  final Color fgColor;
  final bool hasBorder;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DateCubit, DateTime?>(
      builder: (context, selectedDate) {
        void pickDate() async {
          DateTime? picked = await showDatePicker(
            context: context,
            initialDate: selectedDate ?? DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );

          if (picked != null && picked != selectedDate) {
            context.read<DateCubit>().setDate(picked);
          }
        }

        return InkWell(
          onTap: pickDate,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: height,
            width: width,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: bgColor,
              border: hasBorder && borderColor != null
                  ? Border.all(color: borderColor!, width: 2)
                  : null,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                selectedDate == null
                    ? label
                    : "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                style: TextStyle(color: fgColor),
              ),
            ),
          ),
        );
      },
    );
  }
}
