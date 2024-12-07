import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({super.key, required this.tile, this.backgroundColor, required this.borderRadius, this.onTap, this.boxShadow});

  final ListTile tile;
  final Color? backgroundColor;
  final double borderRadius;
  final Function()? onTap;
  final BoxShadow? boxShadow;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: boxShadow != null ? [boxShadow!] : [],),
        child: tile,
      ),
    );
  }
}
