import 'package:flutter/material.dart';

class CustomTintedIconButton extends StatelessWidget {
  const CustomTintedIconButton(
      {super.key,
      required this.child,
      required this.onPressed,
      this.hasCount,
      this.count});
  final Widget child;
  final Function() onPressed;
  final bool? hasCount;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        clipBehavior: Clip.none, // To allow the counter to overflow
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            margin: EdgeInsets.only(
              right: hasCount != null && hasCount! ? 10 : 0,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: child,
          ),

          // Count
          if (hasCount != null && hasCount! && count != null)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(
                    6), // Adjust padding for the counter size
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
