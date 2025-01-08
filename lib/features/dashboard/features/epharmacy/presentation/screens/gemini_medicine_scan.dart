import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/logics/gemini_controller.dart';

class GeminiMedicineScan extends StatelessWidget {
  const GeminiMedicineScan({super.key});

  @override
  Widget build(BuildContext context) {
    // get theme:
    final theme = Theme.of(context).colorScheme;

    // get controller:
    final GeminiController _controller = Get.put(GeminiController());

    return SafeArea(
        child: Scaffold(
      backgroundColor: theme.surfaceContainer,
    ));
  }
}
