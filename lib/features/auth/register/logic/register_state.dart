import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable{
  @override
  List<Object?> get props => [];
}

class RegisterInitialState extends RegisterState{}
class RegisterLoadingState extends RegisterState{}
class RegisterSuccessState extends RegisterState{
  final String message;
  RegisterSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}
class RegisterErrorState extends RegisterState{
  final String message;
  RegisterErrorState(this.message);

  @override
  List<Object?> get props => [message];
}