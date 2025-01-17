import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/common/utils/epharmacy_util.dart';
import 'package:meditouch/common/widgets/custom_loading_animation.dart';

import '../../../epharmacy/data/model/medicine_model.dart';
import '../../logics/order_bloc.dart';
import '../../logics/order_event.dart';
import '../../logics/order_state.dart';
import 'parts/order_appbar.dart';
import 'parts/order_body_medicine_names.dart';
import 'parts/order_medicine_avatars.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // get theme
    final theme = Theme.of(context).colorScheme;

    // load the orders
    BlocProvider.of<OrderBloc>(context).add(const OrderLoad());

    return Scaffold(
          // set background color
          backgroundColor: theme.surfaceContainer,
          // custom app bar
          appBar: ordersAppBar(context, theme),
    
          // custom body
          body: SafeArea(
            child: BlocBuilder<OrderBloc, OrderState>(
                builder: (context, state) {
                  if (state is OrderLoading) {
                    return CustomLoadingAnimation(size: 30, color: theme.primary);
                  }
                
                  if (state is OrderLoaded) {
                    return RefreshIndicator(
              onRefresh: () => Future.sync(() {
                    BlocProvider.of<OrderBloc>(context)
                        .add(const OrderLoad());
                  }),
              child: ordersBody(context, theme, state));
                  }
                
                  if (state is OrderError) {
                    return Center(
            child: Text(state.message),
                    );
                  }
                
                  return Container();
                },
            ),
          ),
        );
  }
}

// custom body for orders screen
Column ordersBody(BuildContext context, ColorScheme theme, OrderLoaded state) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // orders list
      Expanded(
        child: state.orders.isEmpty
            ? const Center(
                child: Text('No orders found'),
              )
            : ListView.builder(
                itemCount: state.orders.length,
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.only(
                        left: 10, right: 15, top: 8, bottom: 8),
                    decoration: BoxDecoration(
                      color: theme.primary.withOpacity(.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        // medicine avatars
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: medicineAvatars(state.orders[index].medicines),
                        ),

                        // medicine names
                        Expanded(
                          child: ordersBodyMedicineNames(state, index, theme),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    ],
  );
}
