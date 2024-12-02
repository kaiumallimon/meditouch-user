import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment(-0.00, -1.00),
        end: Alignment(0, 1),
        colors: [Colors.black, Color(0xFF220041)],
      ),
    ));
  }
}
