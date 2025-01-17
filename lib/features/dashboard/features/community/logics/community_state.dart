import 'package:equatable/equatable.dart';
import '../data/models/community_model.dart';

abstract class CommunityState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CommunityInitial extends CommunityState {}

class CommunityLoading extends CommunityState {}

class CommunityLoaded extends CommunityState {
  final List<CommunityModel> posts;

  CommunityLoaded(this.posts);

  @override
  List<Object?> get props => [posts];
}

class CommunityError extends CommunityState {
  final String error;

  CommunityError(this.error);

  @override
  List<Object?> get props => [error];
}
