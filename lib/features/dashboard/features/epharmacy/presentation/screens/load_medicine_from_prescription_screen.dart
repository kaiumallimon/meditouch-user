import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditouch/features/dashboard/features/cart/data/cart_repository.dart';
import 'package:meditouch/features/dashboard/features/cart/models/cart_model.dart';

import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../../../../common/repository/hive_repository.dart';
import '../../../../../../common/utils/epharmacy_util.dart';
import '../../data/model/combined_medicine.dart';

class CombinedMedicinePage extends StatefulWidget {
  final List<CombinedMedicine> combinedMedicines;

  CombinedMedicinePage({required this.combinedMedicines});

  @override
  _CombinedMedicinePageState createState() => _CombinedMedicinePageState();
}

class _CombinedMedicinePageState extends State<CombinedMedicinePage> {
  // To store the quantity entered for each medicine
  Map<int, TextEditingController> quantityControllers = {};

  // Track which medicines are selected
  Map<int, bool> selectedMedicines = {};

  @override
  void initState() {
    super.initState();
    // Initialize TextEditingControllers and selectedMedicines for each medicine
    for (int i = 0; i < widget.combinedMedicines.length; i++) {
      quantityControllers[i] =
          TextEditingController(text: '1'); // Default quantity is 1
      selectedMedicines[i] = false; // Default: not selected
    }
  }

  @override
  void dispose() {
    // Dispose the controllers to avoid memory leaks
    quantityControllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            CustomAppBar(
              title: 'Medicines',
              subtitle: 'From Prescription',
              textColor: theme.primary,
              textSize: 18,
              bgColor: theme.surface,
            ),
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20),
                itemCount: widget.combinedMedicines.length,
                itemBuilder: (context, index) {
                  final combinedMedicine = widget.combinedMedicines[index];
                  final quantityController = quantityControllers[index]!;

                  // Determine the container color based on selection
                  bool isSelected = selectedMedicines[index] ?? false;
                  Color containerColor = isSelected
                      ? theme.secondary // Highlight color when selected
                      : theme.primary; // Default color when not selected

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        // Toggle selection state
                        selectedMedicines[index] = !isSelected;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: containerColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${combinedMedicine.prescriptionName}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: theme.onPrimary),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Strength: ${combinedMedicine.prescriptionStrength}',
                            style:
                                TextStyle(fontSize: 16, color: theme.onPrimary),
                          ),
                          SizedBox(height: 5),
                          combinedMedicine.searchResult.unitPrices.isNotEmpty
                              ? Text(
                                  'Price: BDT ${combinedMedicine.searchResult.unitPrices[0].price} (${combinedMedicine.searchResult.unitPrices[0].unit})',
                                  style: TextStyle(
                                      fontSize: 16, color: theme.onPrimary),
                                )
                              : Text(
                                  'Price: Not available',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                  ),
                                ),
                          SizedBox(height: 10),
                          // Quantity TextField
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Enter Quantity:',
                                style: TextStyle(
                                    fontSize: 16, color: theme.onPrimary),
                              ),
                              Container(
                                width: 50,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: theme.onPrimary,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: TextField(
                                  controller: quantityController,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    color: theme.primary,
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Add to Cart Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: CustomTextButton(
                height: 50,
                width: double.infinity,
                bgColor: theme.primary,
                fgColor: theme.onPrimary,
                text: "Add selected to the cart",
                // onTap: () {},
                onTap: _addToCart,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart() async {
    List<Map<String, dynamic>> cartItems = [];
    bool allSuccess = true;

    // Show loading indicator (optional)
    showCustomLoadingDialog(context);

    // Loop through combinedMedicines and their respective quantities
    for (int i = 0; i < widget.combinedMedicines.length; i++) {
      if (selectedMedicines[i] == true) {
        final medicine = widget.combinedMedicines[i];
        final quantityController = quantityControllers[i];
        final quantityText = quantityController!.text;
        int quantity =
            int.tryParse(quantityText) ?? 1; // Default to 1 if input is invalid

        // Ensure the medicine has unitPrices available
        if (medicine.searchResult.unitPrices.isNotEmpty) {
          final unitPrice = medicine.searchResult.unitPrices[0];
          final totalPrice = quantity * unitPrice.price;

          final discountAmount = medicine.searchResult.discountValue;
          final discountType = medicine.searchResult.discountType;
          final discount = discountType == 'Percentage' ? discountAmount : 0;

          double discountedPrice = totalPrice - totalPrice * discount / 100;

          if (discount > 0) {
            discountedPrice = totalPrice - (totalPrice * discount / 100);
          }

          final user = await HiveRepository().getUserInfo();

          // Add the item to the cart (calling the backend service)
          final cartItem = CartModel(
              userId: user!['id'],
              medicine: medicine.searchResult,
              quantity: quantity,
              unitIndex: 0,
              totalPrice: totalPrice,
              cartId: "",
              discountedPrice: discountedPrice,
              createdAt: DateTime.now());
          final response = await CartRepository().addToCart(cartItem);

          // Check if the response was successful
          if (!response['status']) {
            allSuccess = false;
          }

          // Add the successful item to the cart list (for display/logging)
          cartItems.add({
            'medicine_name': medicine.prescriptionName,
            'quantity': quantity,
            'unit_price': unitPrice.price,
            'total_price': totalPrice,
          });
        }
      }

      // Hide loading indicator (optional)
      hideCustomLoadingDialog(context);

      // // Show result message based on success or failure
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(allSuccess
      //         ? '${cartItems.length} medicines added to cart!'
      //         : 'Failed to add some medicines to the cart.'),
      //   ),
      // );

      if (allSuccess) {
        showCustomAlert(
            context, "Medicines added to the cart", Colors.green, Colors.white);

        // Clear the cartItems list
        cartItems.clear();
      } else {
        showCustomAlert(context, "Failed to add some medicines to the cart",
            Colors.red, Colors.white);
      }

      // Pop the page
      Navigator.of(context).pop();

    }
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar(
      {super.key,
      required this.title,
      required this.textColor,
      required this.textSize,
      this.subtitle,
      this.subtitleSize,
      this.subtitleColor,
      required this.bgColor,
      this.hasBackButton = false,
      this.onTap,
      this.vPadding = 22,
      this.hPadding = 20,
      this.backButtonBorderColor = Colors.transparent,
      this.trailing});

  final String title;
  final Color textColor;
  final double textSize;
  final String? subtitle;
  final double? subtitleSize;
  final Color? subtitleColor;
  final Color bgColor;
  final bool hasBackButton;
  final Color backButtonBorderColor;
  final Widget? trailing;
  final double vPadding;
  final double hPadding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: bgColor),
      padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
      child: Row(
        children: [
          if (hasBackButton == true)
            IconButton(
              onPressed: onTap ?? () => Navigator.of(context).pop(),
              icon: Icon(Icons.arrow_back_ios),
              color: textColor,
            ),
          Expanded(
            child: Transform.translate(
              offset: hasBackButton && trailing != null
                  ? Offset(0, 0)
                  : hasBackButton
                      ? Offset(-20, 0)
                      : Offset(0, 0),
              child: Column(
                crossAxisAlignment: hasBackButton
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        color: textColor,
                        fontSize: textSize,
                        fontWeight: FontWeight.w600),
                  ),
                  if (subtitle != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          subtitle!,
                          style: TextStyle(
                              fontSize: subtitleSize, color: subtitleColor),
                        )
                      ],
                    )
                ],
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

void hideCustomLoadingDialog(BuildContext context) {
  Navigator.of(context).pop();
}

void showCustomAlert(
    BuildContext context, String message, Color bgColor, Color fgColor) {
  QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      text: message,
      barrierDismissible: false);
}

void showCustomLoadingDialog(BuildContext context) {
  QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      barrierDismissible: false);
}

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.height,
    required this.width,
    required this.bgColor,
    required this.fgColor,
    required this.text,
    required this.onTap,
    this.isLoading,
  });

  final double height;
  final double width;
  final Color bgColor;
  final Color fgColor;
  final bool? isLoading; // This can be null
  final String text;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: isLoading == true // Check if isLoading is true
            ? Center(
                child: CupertinoActivityIndicator(
                  radius: 10,
                  color: fgColor,
                ),
              )
            : Text(
                text,
                style: TextStyle(color: fgColor, fontSize: 15),
              ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.height,
      required this.width,
      required this.bgColor,
      required this.fgColor,
      required this.hint,
      this.isPassword = false,
      this.borderRadius = 10,
      this.controller,
      this.paddingH = 13,
      this.expands = false,
      this.iconColor,
      this.iconPath,
      this.onChanged});

  final double height;
  final double width;
  final Color bgColor;
  final Color fgColor;
  final String hint;
  final bool isPassword;
  final String? iconPath;
  final Color? iconColor;
  final double borderRadius;
  final TextEditingController? controller;
  final double paddingH;
  final bool expands;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: EdgeInsets.symmetric(horizontal: paddingH),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Center items vertically
        children: [
          if (iconPath != null)
            Image.asset(iconPath!, scale: 1.4, color: iconColor!),
          if (iconPath != null) const SizedBox(width: 10),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              maxLines: expands ? null : 1,
              expands: expands,
              controller: controller,
              obscureText: isPassword,
              style: TextStyle(fontSize: 15, color: fgColor),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: fgColor.withOpacity(.5),
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                    vertical: (height - 20) / 2), // Center the text vertically
              ),
            ),
          ),
        ],
      ),
    );
  }
}
