import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/common/repository/hive_repository.dart';

import '../../../../../../../common/widgets/custom_button.dart';
import '../../../../epharmacy/data/model/medicine_model.dart';
import '../../../../order/data/models/order_model.dart';
import '../../../logics/cart_bloc.dart';
import '../../../logics/cart_event.dart';
import '../../../models/cart_model.dart';
import 'checkout_cart_view.dart';

Widget checkoutButton(BuildContext context, ColorScheme theme,
    List<CartModel> cartItems, String address, List<String> selectedItems) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      CustomButton(
          size: const Size(120, 45),
          text: "Checkout",
          onPressed: () async {
            // get user details
            final user = await HiveRepository().getUserInfo();

            final uid = user!['id'];

            // extract medicines from cart items
            List<Medicine> medicines = [];

            cartItems.forEach((cartItem) {
              medicines.add(cartItem.medicine);
            });

            final double totalPrice = calculateTotalPrice(cartItems);

            final String paymentMethod =
                context.read<PaymentCubit>().state.toString();

            BlocProvider.of<CartBloc>(context).add(CheckoutRequested(
                selectedItems,
                OrderModel(
                    medicines: medicines,
                    uid: uid,
                    orderStatus: 'Processing',
                    orderDate: DateTime.now(),
                    deliveryAddress: address,
                    userPhoneNumber: user['phone'],
                    userFullName: user['name'],
                    paymentMethod: paymentMethod,
                    paymentStatus: 'pending',
                    totalPrice: totalPrice > 500 ? totalPrice : totalPrice + 50,
                    orderId: "")));

            context.read<AddressCubit>().clearAddress();
          },
          bgColor: theme.primary,
          fgColor: theme.onPrimary,
          isLoading: false),
    ],
  );
}
