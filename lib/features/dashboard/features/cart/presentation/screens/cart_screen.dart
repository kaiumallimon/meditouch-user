import 'package:flutter/services.dart';
import 'package:meditouch/app/app_exporter.dart';
import 'package:meditouch/common/widgets/custom_loading_animation.dart';
import 'package:meditouch/features/dashboard/features/cart/presentation/screens/parts/cart_appbar.dart';

import '../../logics/cart_bloc.dart';
import '../../logics/cart_event.dart';
import '../../logics/cart_state.dart';
import 'parts/cart_body.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: theme.surfaceContainer,
      statusBarIconBrightness: theme.brightness,
    ));

    context.read<CartBloc>().add(LoadCart());

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.surface,
        appBar: cartAppBar(context, theme),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<CartBloc>().add(LoadCart());
          },
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoading) {
                return CustomLoadingAnimation(size: 30, color: theme.primary);
              } else if (state is CartLoaded) {
                return cartBody(context, theme, state.cartItems, state);
              } else if (state is CartError) {
                return Center(
                  child: Text(
                    state.message,
                    style: TextStyle(color: theme.error),
                  ),
                );
              }
              return const Center(child: Text("No data available"));
            },
          ),
        ),
        floatingActionButton: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            return state is CartLoaded && state.selectedItems.isNotEmpty
                ? FloatingActionButton.extended(
                    backgroundColor: theme.secondary,
                    foregroundColor: theme.onSecondary,
                    onPressed: () {
                      // go to the checkout screen
                    },
                    label: const Text("Proceed to checkout"),
                  )
                : const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
