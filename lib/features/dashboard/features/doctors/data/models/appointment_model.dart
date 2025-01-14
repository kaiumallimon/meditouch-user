import 'package:equatable/equatable.dart';

class AppointmentModel extends Equatable {
  final String appointmentId;
  final String doctorId;
  final String patientId;
  final Map<String, dynamic> patientDetails;
  final String appointmentDate;
  final String appointmentTimeSlot;
  final String bookingTime;
  final bool isCompleted;
  final String paymentStatus;
  final String? videoCallId;
  final String paidAmount;
  final Map<String, dynamic> doctorDetails;

  const AppointmentModel({
    required this.appointmentId,
    required this.doctorId,
    required this.patientId,
    required this.patientDetails,
    required this.appointmentDate,
    required this.appointmentTimeSlot,
    required this.bookingTime,
    required this.isCompleted,
    required this.paymentStatus,
    required this.videoCallId,
    required this.paidAmount,
    required this.doctorDetails,
  });

  factory AppointmentModel.fromJson(
      Map<String, dynamic> json, String appointmentId) {
    return AppointmentModel(
      appointmentId: appointmentId,
      doctorId: json['doctorId'],
      patientId: json['patientId'],
      patientDetails: json['patientDetails'],
      appointmentDate: json['appointmentDate'],
      appointmentTimeSlot: json['appointmentTimeSlot'],
      bookingTime: json['bookingTime'],
      isCompleted: json['isCompleted'],
      paymentStatus: json['paymentStatus'],
      videoCallId: json['videoCallId'],
      paidAmount: json['paidAmount'],
      doctorDetails: json['doctorDetails'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'patientId': patientId,
      'patientDetails': patientDetails,
      'appointmentDate': appointmentDate,
      'appointmentTimeSlot': appointmentTimeSlot,
      'bookingTime': bookingTime,
      'isCompleted': isCompleted,
      'paymentStatus': paymentStatus,
      'videoCallId': videoCallId,
      'paidAmount': paidAmount,
      'doctorDetails': doctorDetails,
    };
  }

  @override
  List<Object?> get props => [
        appointmentId,
        doctorId,
        patientId,
        patientDetails,
        appointmentDate,
        appointmentTimeSlot,
        bookingTime,
        isCompleted,
        paymentStatus,
        videoCallId,
        paidAmount,
        doctorDetails,
      ];
}
