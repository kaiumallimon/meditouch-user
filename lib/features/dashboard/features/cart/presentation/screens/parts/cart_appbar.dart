import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/features/dashboard/features/cart/logics/cart_event.dart';
import 'package:quickalert/quickalert.dart';

import '../../../logics/cart_bloc.dart';
import '../../../logics/cart_state.dart';

AppBar cartAppBar(BuildContext context, ColorScheme theme) {
  return AppBar(
    backgroundColor: theme.surfaceContainer,
    elevation: 0,
    surfaceTintColor: theme.surfaceContainer,
    title: Text(
      'Cart',
      style: TextStyle(color: theme.onSurface),
    ),
    actions: [
      BlocBuilder<CartBloc, CartState>(builder: (context, state) {
        if (state is CartLoaded && state.selectedItems.isNotEmpty) {
          return IconButton(
            icon: Icon(
              Icons.delete,
              size: 20,
              color: theme.error,
            ),
            onPressed: () {
              // Show a confirmation dialog
              QuickAlert.show(
                context: context,
                type: QuickAlertType.confirm,
                title: 'Remove items from cart?',
                text:
                    'Are you sure you want to remove selected items from cart?',
                confirmBtnText: "Remove",
                onCancelBtnTap: () {
                  Navigator.of(context)
                      .pop(); // Close confirmation dialog on cancel
                },
                onConfirmBtnTap: () async {
                  // Show loading dialog when removal is initiated
                  Navigator.of(context).pop(); // Close confirmation dialog
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.loading,
                    title: 'Removing...',
                    text:
                        'Please wait while we remove the items from your cart.',
                    confirmBtnText: "Cancel",
                    onConfirmBtnTap: () {
                      Navigator.of(context).pop(); // Close loading dialog
                    },
                  );

                  // Trigger the BLoC event to remove the selected items
                  BlocProvider.of<CartBloc>(context)
                      .add(RemoveFromCart(state.selectedItems));

                  // After removal, close the loading dialog and show success/failure
                  Navigator.of(context).pop(); // Close loading dialog
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    title: 'Items removed!',
                    text: 'The selected items have been removed from the cart.',
                  );
                },
              );
            },
          );
        }
        return const SizedBox.shrink();
      }),
      const SizedBox(width: 10),
    ],
  );
}
