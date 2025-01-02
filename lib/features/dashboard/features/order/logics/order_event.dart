import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class OrderLoad extends OrderEvent {
  const OrderLoad();

  @override
  List<Object> get props => [];
}

// order_event.dart
class FilterOrders extends OrderEvent {
  final String filter;
  const FilterOrders(this.filter);

  @override
  List<Object> get props => [filter];
}
