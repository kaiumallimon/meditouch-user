import 'package:equatable/equatable.dart';

abstract class AppointmentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchAppointments extends AppointmentEvent {

  FetchAppointments();

  @override
  List<Object?> get props => [];
}
