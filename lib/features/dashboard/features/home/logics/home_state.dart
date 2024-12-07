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
  HomeLoaded(this.userInfo);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}