import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:meditouch/common/repository/hive_repository.dart';
import 'package:meditouch/common/widgets/custom_button.dart';
import 'package:meditouch/features/dashboard/features/doctors/data/models/doctor_model.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../logics/payment_bloc.dart';
import '../../logics/payment_events.dart';
import '../../logics/payment_states.dart';
import 'payment_screen.dart';

class AppointmentBookScreen extends StatelessWidget {
  const AppointmentBookScreen(
      {super.key,
      required this.date,
      required this.timeSlotIndex,
      required this.doctor,
      required this.user});

  final String date;
  final int timeSlotIndex;
  final DoctorModel doctor;
  final Map<String, dynamic> user;

  @override
  Widget build(BuildContext context) {
    // get the theme
    final theme = Theme.of(context).colorScheme;

    // inject the controller

    return Scaffold(
      backgroundColor: theme.surfaceContainer,
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: theme.surfaceContainer,
        title: const Text(
          "Book an appointment",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.surfaceContainer,
        toolbarHeight: 70,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Doctor info
              ///
              ///
              ///
              /// Doctor details card
              Text(
                'Doctor Information',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.primary,
                ),
              ),

              const SizedBox(height: 15),

              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: theme.primary.withOpacity(.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: doctor.imageUrl,
                        height: 140,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctor.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: theme.primary,
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              doctor.specialization,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.onPrimary),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text('Appointment time:',
                              style: TextStyle(
                                  color: theme.onSurface.withOpacity(.5))),
                          const SizedBox(height: 5),
                          Text(
                            '$date (${doctor.timeSlots[date]![timeSlotIndex]['time']})',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: theme.primary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// Doctor fee card
              ///
              ///

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: theme.primary.withOpacity(.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Visiting Fee',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: theme.onSurface.withOpacity(.5),
                      ),
                    ),
                    Text(
                      'BDT. ${doctor.visitingFee}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// Patient info card
              ///
              ///
              ///
              ///
              Text(
                'Patient Information',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.primary,
                ),
              ),

              const SizedBox(height: 15),

              Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: theme.primary.withOpacity(.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: user!['image'],
                            height: 170,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: theme.onSurface.withOpacity(.5),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    user['name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: theme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Email',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: theme.onSurface.withOpacity(.5),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    user['email'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: theme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Phone',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: theme.onSurface.withOpacity(.5),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    user['phone'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: theme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Continue
                  ///
                  /// to
                  ///
                  /// payment
                  ///
                  ///
                  /// to book the appointment
                  Text(
                    'Go ahead and pay the visiting fee to book the appointment.',
                    style: TextStyle(
                      color: theme.onSurface.withOpacity(.5),
                    ),
                  ),

                  const SizedBox(height: 20),

                  BlocConsumer<PaymentBloc, PaymentState>(
                    listener: (context, state) {
                      if (state is PaymentSuccess) {
                        QuickAlert.show(
                          context: context,
                          title: 'Success',
                          text: "Appointment booked successfully!",
                          type: QuickAlertType.success,
                          onConfirmBtnTap: () => Navigator.pop(context),
                        );
                      }
                      if (state is PaymentTokenGranted) {
                        /// Create payment
                        ///
                        /// For now, the amount is fixed to 1
                        ///
                        /// Test with 1 BDT

                        context.read<PaymentBloc>().add(CreatePaymentRequested(
                              grantToken: state.grantToken,
                              amount: '1',
                            ));
                      }

                      if (state is PaymentCreated) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PaymentScreen(
                              appointmentDate: date,
                              appointmentTimeSlot: doctor
                                  .timeSlots[date]![timeSlotIndex]['time'],
                              doctorModel: doctor,
                              patientDetails: user,
                              patientId: user['id'],
                              paymentUrl: state.paymentUrl,
                            ),
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return CustomButton(
                        size: const Size(600, 50),
                        text: "Pay now",
                        onPressed: () {
                          context
                              .read<PaymentBloc>()
                              .add(GrantTokenRequested());
                        },
                        bgColor: theme.primary,
                        fgColor: theme.onPrimary,
                        isLoading: state is PaymentLoading,
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
