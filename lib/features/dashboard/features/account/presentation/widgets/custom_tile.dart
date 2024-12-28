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
      this.padding = 0,
      this.onTap});

  final Color tileColor;
  final double borderRadius;
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final Function? onTap;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ListTile(
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          selectedColor: Colors.transparent,

          // contentPadding: EdgeInsets.all(padding),
          leading: leading,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
        ),
      ),
    );
  }
}
