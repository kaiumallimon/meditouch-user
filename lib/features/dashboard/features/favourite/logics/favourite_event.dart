import 'package:equatable/equatable.dart';

abstract class FavouriteEvent extends Equatable {
  const FavouriteEvent();

  @override
  List<Object> get props => [];
}


class AddToFavourite extends FavouriteEvent {
  final String userId;
  final String medicineId;

  const AddToFavourite({required this.userId, required this.medicineId});

  @override
  List<Object> get props => [userId, medicineId];
}

class RemoveFromFavourite extends FavouriteEvent {
  final String favouriteId;

  const RemoveFromFavourite({required this.favouriteId});

  @override
  List<Object> get props => [favouriteId];
}

class FetchFavouriteList extends FavouriteEvent {
  final String userId;

  const FetchFavouriteList({required this.userId});

  @override
  List<Object> get props => [userId];
}