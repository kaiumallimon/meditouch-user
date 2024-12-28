import 'package:flutter/cupertino.dart';

class CustomMultipletile extends StatelessWidget {
  const CustomMultipletile({super.key, required this.children, required this.backgroundColor, required this.borderRadius, required this.seperatorColor, required this.padding});

  final List<Widget> children;
  final Color backgroundColor;
  final double borderRadius;
  final Color seperatorColor;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: EdgeInsets.all(padding),
      child: Column(
        children: children.map((e) {
          return Column(
            children: [
              e,
              if (children.indexOf(e) != children.length - 1)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  height: 1,
                  color: seperatorColor,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
