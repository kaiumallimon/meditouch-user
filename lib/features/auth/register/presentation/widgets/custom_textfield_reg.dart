import 'package:flutter/material.dart';
import 'package:r_icon_pro/r_icon_pro.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield(
      {super.key,
      required this.hint,
      required this.size,
      required this.bgColor,
      required this.fgColor,
      required this.controller,
      required this.iconData});

  final String hint;
  final Size size;
  final Color bgColor;
  final Color fgColor;
  final IconData iconData;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Icon(
            iconData,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(
                color: fgColor,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: hint,
                  hintStyle: TextStyle(color: fgColor.withOpacity(.4))),
            ),
          ),
        ],
      ),
    );
  }
}
