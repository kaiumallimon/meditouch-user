import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class HomeGridItem extends StatelessWidget {
  const HomeGridItem(
      {super.key,
      required this.backgroundColor,
      required this.textColor,
      required this.title,
      required this.icon,
      required this.onTap});
  final Color backgroundColor;
  final Color textColor;
  final String title;
  final Widget icon;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
