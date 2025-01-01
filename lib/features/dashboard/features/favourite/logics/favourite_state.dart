import 'package:equatable/equatable.dart';

abstract class FavouriteState extends Equatable {
  const FavouriteState();

  @override
  List<Object> get props => [];
}

class FavouriteInitial extends FavouriteState {}

class FavouriteLoading extends FavouriteState {}

class FavouriteLoaded extends FavouriteState {
  final List<String> favouriteIds;

  const FavouriteLoaded({required this.favouriteIds});

  @override
  List<Object> get props => [favouriteIds];
}

class FavouriteError extends FavouriteState {
  final String message;

  const FavouriteError({required this.message});

  @override
  List<Object> get props => [message];
}

class FavouriteAdded extends FavouriteState {
  final String favouriteId;

  const FavouriteAdded({required this.favouriteId});

  @override
  List<Object> get props => [favouriteId];
}
