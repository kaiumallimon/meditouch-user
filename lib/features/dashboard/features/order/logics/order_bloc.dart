import 'dart:async';
import 'package:meditouch/common/repository/hive_repository.dart';
import 'package:meditouch/features/dashboard/features/order/data/models/order_model.dart';
import 'package:meditouch/features/dashboard/features/order/data/repository/order_repository.dart';
import './order_event.dart';
import './order_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(const OrderInitial()) {
    on<OrderLoad>(_onOrderLoad);
    on<FilterOrders>(_onFilterOrders);
  }

  // load the orders
  FutureOr<void> _onOrderLoad(OrderLoad event, Emitter<OrderState> emit) async {
    // emit loading state
    emit(const OrderLoading());

    try {
      // get uid
      final user = await HiveRepository().getUserInfo();
      final String uid = user!['id'];

      // fetch orders
      final orderResponse = await OrderRepository().getOrders(uid);

      // sort the orders in descending order
      orderResponse.orders!.sort((a, b) => b.orderDate.compareTo(a.orderDate));

      // emit loaded state
      if (orderResponse.status) {
        emit(OrderLoaded(orderResponse.orders!));
      } else {
        emit(OrderError(orderResponse.message));
      }
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  // Filter orders based on the status
  FutureOr<void> _onFilterOrders(
      FilterOrders event, Emitter<OrderState> emit) async {
    emit(OrderLoading());

    //// get uid
    final user = await HiveRepository().getUserInfo();
    final String uid = user!['id'];

    // prcoess server response
    if (event.filter == 'All') {
      // load all orders
      final orderResponse = await OrderRepository().getOrders(uid);
      if (orderResponse.status) {
        emit(OrderLoaded(orderResponse.orders!));
      } else {
        emit(OrderError(orderResponse.message));
      }
    } else if (event.filter == 'Pending') {
      // load pending orders
      final pendingOrders = await OrderRepository().getPendingOrders(uid);
      emit(OrderLoaded(pendingOrders.orders!));
    } else {
      final deliveredOrders = await OrderRepository().getDeliveredOrders(uid);
      emit(OrderLoaded(deliveredOrders.orders!));
    }
  }
}
