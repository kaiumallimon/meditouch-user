import 'package:equatable/equatable.dart';
import 'package:meditouch/features/dashboard/features/order/data/models/order_model.dart';

abstract class OrderEvent extends Equatable{
  const OrderEvent();

  @override
  List<Object> get props => [];
}


class OrderCheckout extends OrderEvent{
  final OrderModel orderModel;
  final List<String> cartIds;

  const OrderCheckout(this.orderModel, this.cartIds);

  @override
  List<Object> get props => [orderModel, cartIds];
}

