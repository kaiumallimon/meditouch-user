import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}


class HomeLoaded extends HomeState {
  final Map<String, dynamic> userInfo;
  final int cartItemsCount;
  HomeLoaded(this.userInfo, this.cartItemsCount);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}