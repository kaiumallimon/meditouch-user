import 'package:equatable/equatable.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  final String message;
  const OrderLoaded(this.message);
}

class OrderError extends OrderState {
  final String message;
  const OrderError(this.message);
}

class OrderCheckoutSuccess extends OrderState {
  final String message;
  const OrderCheckoutSuccess(this.message);
}

class OrderCheckoutError extends OrderState {
  final String message;
  const OrderCheckoutError(this.message);
}
