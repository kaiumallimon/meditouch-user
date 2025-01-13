import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditouch/app/app_exporter.dart';
import 'package:meditouch/common/models/bkash_create_payment_response.dart';
import 'package:meditouch/common/widgets/custom_loading_animation.dart';
import 'package:meditouch/features/dashboard/features/doctors/data/models/doctor_model.dart';
import 'package:meditouch/features/dashboard/features/doctors/logics/payment_bloc.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../logics/payment_events.dart';
import '../../logics/payment_states.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen(
      {super.key,
      required this.appointmentDate,
      required this.appointmentTimeSlot,
      required this.doctorModel,
      required this.patientDetails,
      required this.paymentUrl,
      required this.patientId});

  final String appointmentDate;
  final String appointmentTimeSlot;
  final DoctorModel doctorModel;
  final Map<String, dynamic> patientDetails;
  final String patientId;
  final String paymentUrl;

  @override
  Widget build(BuildContext context) {
    // get theme:
    final theme = Theme.of(context).colorScheme;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.onSurface),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
        title: Text('Bkash Payment'),
        backgroundColor: theme.surfaceContainer,
        elevation: 0,
        surfaceTintColor: theme.surfaceContainer,
      ),
      body: BlocConsumer<PaymentBloc, PaymentState>(builder: (context, state) {
        if (state is PaymentLoading) {
          return CustomLoadingAnimation(size: 25, color: theme.primary);
        }

        if (state is PaymentFailure) {
          return Center(
            child: Text(state.errorMessage),
          );
        }

        if (state is PaymentCreated) {
          return WebViewWidget(
              controller: WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..setNavigationDelegate(
                    NavigationDelegate(onPageFinished: (String url) async {
                  if (url.contains('success')) {
                    /// execute payment
                    ///
                    /// then
                    ///
                    /// book appointment
                    ///
                    /// and create a notification
                    ///

                    context.read<PaymentBloc>().add(ExecutePaymentRequested(
                        paymentId: state.paymentId,
                        grantToken: state.grantToken,
                        doctor: doctorModel,
                        patientDetails: patientDetails,
                        appointmentDate: appointmentDate,
                        appointmentTimeSlot: appointmentTimeSlot));
                  } else if (url.contains('cancel')) {
                    BlocProvider.of<PaymentBloc>(context)
                        .add(PaymentGotError('Payment cancelled'));
                  } else if (url.contains('failure')) {
                    BlocProvider.of<PaymentBloc>(context)
                        .add(PaymentGotError('Payment failed'));
                  }
                }))
                ..loadRequest(Uri.parse(paymentUrl)));
        }
        if (state is PaymentSuccess) {
          return Center(
            child: Text(state.message),
          );
        }

        return Container();
      }, listener: (context, state) {
        Navigator.pop(context);
        Navigator.pop(context);
      }),
    ));
  }
}
