import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoginInitialState extends LoginState{}
class LoginLoadingState extends LoginState{}
class LoginSuccessState extends LoginState{
  final String message;

  LoginSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}

class LoginErrorState extends LoginState{
  final String message;

  LoginErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

