import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.centerTitle = false,
    this.backgroundColor,
    this.titleColor,
    this.elevation = 0,
    this.titleStyle,
  });

  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? titleColor;
  final double elevation;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.11),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leading != null) leading!,
            if (leading == null)
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.of(context).pop(),
              ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: titleStyle ??
                    TextStyle(
                      color:
                          titleColor ?? Theme.of(context).colorScheme.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: centerTitle ? TextAlign.center : TextAlign.start,
              ),
            ),
            if (actions != null) ...actions!,
          ],
        ));
  }
}
