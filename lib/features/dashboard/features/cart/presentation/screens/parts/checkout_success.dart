import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../../../../common/widgets/custom_button.dart';

Center checkoutSuccess(ColorScheme theme, BuildContext context) {
    return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/lottie/success_.json',
                  height: 100,
                  width: 100,
                  fit: BoxFit.contain,
                  repeat: false,
                ),
                const SizedBox(height: 15),
                Text(
                  'Order Placed!',
                  style: TextStyle(
                    color: theme.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  size: const Size(120, 45),
                  text: "Exit",
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  bgColor: theme.primary,
                  fgColor: theme.onPrimary,
                  isLoading: false,
                ),
              ],
            ),
          );
  }
