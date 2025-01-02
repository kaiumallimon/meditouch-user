import 'package:equatable/equatable.dart';
import 'package:meditouch/features/dashboard/features/order/data/models/order_model.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {
  const OrderInitial();

  @override
  List<Object> get props => [];
}

class OrderLoading extends OrderState {
  const OrderLoading();

  @override
  List<Object> get props => [];
}

class OrderLoaded extends OrderState {
  final List<OrderModel> orders;
  final String filter;
  const OrderLoaded(this.orders, {this.filter = 'All'});

  @override
  List<Object> get props => [orders];
}

class OrderError extends OrderState {
  final String message;
  const OrderError(this.message);

  @override
  List<Object> get props => [message];
}
