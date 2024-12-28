import 'package:equatable/equatable.dart';

abstract class AccountStates extends Equatable{
  const AccountStates();
  @override
  List<Object> get props => [];
}

class AccountInitial extends AccountStates {}

class AccountLoading extends AccountStates {}

class AccountLoaded extends AccountStates {
  final Map<String, dynamic> userInfo;
  const AccountLoaded(this.userInfo);

  @override
  List<Object> get props => [userInfo];
}

class AccountError extends AccountStates {
  final String message;
  const AccountError(this.message);

  @override
  List<Object> get props => [message];
}