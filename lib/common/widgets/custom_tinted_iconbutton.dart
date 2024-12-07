
import 'package:flutter/material.dart';

class CustomTintedIconButton extends StatelessWidget {
  const CustomTintedIconButton(
      {super.key, required this.child, required this.onPressed});
  final Widget child;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: child,
      ),
    );
  }
}
