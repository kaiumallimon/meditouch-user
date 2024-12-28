import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object> get props => [message];
}

class ProfileUpdated extends ProfileState {
  final String message;

  const ProfileUpdated({required this.message});

  @override
  List<Object> get props => [message];
}

class ProfileUpdateError extends ProfileState {
  final String message;

  const ProfileUpdateError({required this.message});

  @override
  List<Object> get props => [message];
}

class ProfileEditState extends ProfileState {
  const ProfileEditState();
}

class ProfileEditDoneState extends ProfileState {
  const ProfileEditDoneState();
}
