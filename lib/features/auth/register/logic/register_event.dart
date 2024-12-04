part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  final String name;
  final String phone;
  final String email;
  final String? gender;
  final DateTime? dob;
  final String password;
  final String confirmPassword;
  final XFile? image;

  RegisterSubmitted(
      {required this.name,
      required this.phone,
      required this.email,
      required this.gender,
      required this.dob,
      required this.password,
      required this.confirmPassword,
      required this.image});

  @override
  // TODO: implement props
  List<Object?> get props => [
    this.name,
    this.phone,
    this.email,
    this.gender,
    this.dob,
    this.password,
    this.confirmPassword,
    this.image
  ];
}
