abstract class DetailedDoctorEvent {}

class BookAppointmentEvent extends DetailedDoctorEvent{}

class DetailedDoctorChangeFocusedDate extends DetailedDoctorEvent {
  final DateTime focusedDate;

  DetailedDoctorChangeFocusedDate({required this.focusedDate});
}