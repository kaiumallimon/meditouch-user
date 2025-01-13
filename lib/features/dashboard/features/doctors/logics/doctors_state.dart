import '../data/models/doctor_model.dart';

abstract class DoctorsState {}

class DoctorsStateInitial extends DoctorsState {}

class DoctorsStateLoading extends DoctorsState {}

class DoctorsStateSuccess extends DoctorsState {
  final List<DoctorModel> doctors;

  DoctorsStateSuccess(this.doctors);
}

class DoctorsStateFailure extends DoctorsState {
  final String message;

  DoctorsStateFailure(this.message);
}
