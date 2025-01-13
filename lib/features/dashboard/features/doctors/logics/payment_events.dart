import '../data/models/doctor_model.dart';

abstract class PaymentEvent {}

class GrantTokenRequested extends PaymentEvent {}

class CreatePaymentRequested extends PaymentEvent {
  final String grantToken;
  final String amount;

  CreatePaymentRequested({required this.grantToken, required this.amount});
}

class ExecutePaymentRequested extends PaymentEvent {
  final String paymentId;
  final String grantToken;
  final Map<String, dynamic> patientDetails;
  final DoctorModel doctor;
  final String appointmentDate;
  final String appointmentTimeSlot;

  ExecutePaymentRequested({
    required this.paymentId,
    required this.grantToken,
    required this.patientDetails,
    required this.doctor,
    required this.appointmentDate,
    required this.appointmentTimeSlot,
  });
}

class PaymentGotError extends PaymentEvent {
  final String errorMessage;

  PaymentGotError(this.errorMessage);
}

class PaymentGotLoading extends PaymentEvent {}