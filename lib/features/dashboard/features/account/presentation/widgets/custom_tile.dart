import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  const CustomTile(
      {super.key,
      required this.tileColor,
      required this.borderRadius,
      this.leading,
      required this.title,
      this.subtitle,
      this.trailing,
      this.onTap});

  final Color tileColor;
  final double borderRadius;
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ListTile(
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
        },
      ),
    );
  }
}
