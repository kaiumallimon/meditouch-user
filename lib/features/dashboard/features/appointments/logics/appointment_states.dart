import '../../doctors/data/models/appointment_model.dart';

abstract class AppointmentState {}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoading extends AppointmentState {}

class AppointmentFailure extends AppointmentState {
  final String errorMessage;

  AppointmentFailure(this.errorMessage);
}

class AppointmentSuccess extends AppointmentState {
  final List<AppointmentModel> upcomingAppointments;
  final List<AppointmentModel> pastAppointments;

  AppointmentSuccess(this.upcomingAppointments, this.pastAppointments);
}
