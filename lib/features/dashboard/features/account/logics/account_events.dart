import 'package:equatable/equatable.dart';

abstract class AccountEvents extends Equatable{
  const AccountEvents();
  @override
  List<Object> get props => [];
}

class AccountRefreshRequested extends AccountEvents{
  const AccountRefreshRequested();

  @override
  List<Object> get props => [];
}

class AccountLogoutRequested extends AccountEvents{
  const AccountLogoutRequested();

  @override
  List<Object> get props => [];
}
