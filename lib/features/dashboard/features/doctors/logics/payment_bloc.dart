import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/repository/bkash_repository.dart';
import '../../../../../common/utils/invoice.dart';
import '../data/models/appointment_model.dart';
import '../data/repository/appointment_book_repository.dart';
import 'payment_events.dart';
import 'payment_states.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(PaymentInitial()) {
    on<GrantTokenRequested>(_onGrantTokenRequested);
    on<CreatePaymentRequested>(_onCreatePaymentRequested);
    on<ExecutePaymentRequested>(_onExecutePaymentRequested);
    on<PaymentGotError>(_onPaymentGotError);
    on<PaymentGotLoading>(_onPaymentGotLoading);
  }

  void _onPaymentGotLoading(
      PaymentGotLoading event, Emitter<PaymentState> emit) {
    emit(PaymentLoading());
  }

  void _onPaymentGotError(PaymentGotError event, Emitter<PaymentState> emit) {
    emit(PaymentFailure(event.errorMessage));
  }

  Future<void> _onGrantTokenRequested(
      GrantTokenRequested event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    final grantTokenResponse = await BkashRepository().grantToken();
    if (grantTokenResponse.statusMessage == 'Successful') {
      emit(PaymentTokenGranted(grantTokenResponse.idToken));
    } else {
      emit(PaymentFailure(grantTokenResponse.statusMessage));
    }
  }

  Future<void> _onCreatePaymentRequested(
      CreatePaymentRequested event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    final paymentResponse = await BkashRepository().createPayment(
      idToken: event.grantToken,
      amount: event.amount,
      invoiceNumber: generateInvoice(),
    );
    if (paymentResponse.statusMessage == 'Successful') {
      emit(PaymentCreated(paymentResponse.paymentID, event.grantToken,
          paymentResponse.bkashURL));
    } else {
      emit(PaymentFailure(paymentResponse.statusMessage));
    }
  }

  Future<void> _onExecutePaymentRequested(
      ExecutePaymentRequested event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    final executePaymentResponse =
        await BkashRepository().executePaymentresponse(
      paymentID: event.paymentId,
      idToken: event.grantToken,
    );
    if (executePaymentResponse.statusMessage == 'Successful') {
      final appointmentModel = AppointmentModel(
        appointmentId: '',
        doctorId: event.doctor.id,
        patientId: event.patientDetails['id'],
        patientDetails: event.patientDetails,
        appointmentDate: event.appointmentDate,
        appointmentTimeSlot: event.appointmentTimeSlot,
        bookingTime: DateTime.now().toIso8601String(),
        isCompleted: false,
        paymentStatus: 'paid',
        videoCallId: null,
        paidAmount: executePaymentResponse.amount,
        doctorDetails: event.doctor.toJson(),
      );

      await AppointmentBookRepository()
          .bookAppointment(appointmentModel: appointmentModel);
      emit(PaymentSuccess('Appointment booked successfully'));
    } else {
      emit(PaymentFailure(executePaymentResponse.statusMessage));
    }
  }
}
