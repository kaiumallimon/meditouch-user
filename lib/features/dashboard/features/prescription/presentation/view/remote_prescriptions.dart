import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meditouch/common/widgets/custom_loading_animation.dart';
import 'package:meditouch/features/dashboard/features/doctors/data/models/appointment_model.dart';
import 'package:meditouch/features/dashboard/features/prescription/data/repository/prescription_repository.dart';
import 'package:meditouch/features/dashboard/features/prescription/presentation/view/remote_prescription_details_screen.dart';

import '../../../../../../common/utils/datetime_format.dart';
import '../../../doctors/data/models/doctor_model.dart';

class RemotePrescriptions extends StatelessWidget {
  const RemotePrescriptions({super.key, required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context) {
    // get theme:
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Remote Prescriptions',
            style: TextStyle(color: theme.onSurface)),
        backgroundColor: theme.surfaceContainer,
      ),
      backgroundColor: theme.surfaceContainer,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 15,
          children: [
            Text('To see prescriptions, select an appointment from below.',
                style: TextStyle(color: theme.onSurface.withOpacity(.5))),

            Text('Appointments',
                style: TextStyle(
                    color: theme.primary, fontWeight: FontWeight.bold)),

            // Appointments list
            Expanded(
              child: FutureBuilder<List<AppointmentModel>>(
                  future: PrescriptionRepository().getPastAppointments(userId),
                  builder: (context, appointmentsSnapshot) {
                    if (appointmentsSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                          child: CustomLoadingAnimation(
                              size: 25, color: theme.primary));
                    }

                    if (appointmentsSnapshot.hasError) {
                      return Center(
                          child: Text('Error loading appointments',
                              style: TextStyle(color: theme.error)));
                    }

                    final appointments = appointmentsSnapshot.data!;

                    // Check if there are no appointments
                    if (appointments.isEmpty) {
                      return Center(
                        child: Text(
                          'No appointments found',
                          style: TextStyle(
                              color: theme.onSurface.withOpacity(0.5)),
                        ),
                      );
                    }

                    // Sort appointments by `bookingTime` (descending)
                    //
                    // `bookingTime` is expected to be a DateTime as an ISO8601 string
                    appointments.sort((a, b) {
                      final DateTime bookingTimeA =
                          DateTime.parse(a.bookingTime);
                      final DateTime bookingTimeB =
                          DateTime.parse(b.bookingTime);
                      return bookingTimeB
                          .compareTo(bookingTimeA); // Descending order
                    });

                    return ListView.builder(
                        itemCount: appointments.length,
                        physics: BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(top: 20),
                        itemBuilder: (context, index) {
                          final appointment = appointments[index];
                          final doctorDetails = DoctorModel.fromJson(
                              appointment.doctorDetails, appointment.doctorId);
                          return buildAppointmentCard(
                              context, appointment, theme);
                        });
                  }),
            )
          ],
        ),
      )),
    );
  }

  Widget buildAppointmentCard(
      BuildContext context, AppointmentModel appointment, ColorScheme theme) {
    final doctorDetails = DoctorModel.fromJson(
      appointment.doctorDetails,
      appointment.doctorId,
    );

    return GestureDetector(
      onTap: () {
        // Navigate to the prescription details screen
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DetailedRemotePrescriptionView(
            appointment: appointment,
          )

        ));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: theme.primary.withOpacity(.2)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.surface,
                  backgroundImage:
                      CachedNetworkImageProvider(doctorDetails.imageUrl),
                ),
              ),
              const SizedBox(height: 20), // Space for the avatar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  doctorDetails.name,
                  style: TextStyle(
                    color: theme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              buildSpecializationTag(theme, doctorDetails.specialization),
              const SizedBox(height: 15),
              buildInfoRow(
                theme,
                Icons.calendar_today,
                DateTimeFormatUtil().formatAppointmentTime(
                  appointment.appointmentDate,
                  appointment.appointmentTimeSlot,
                ),
              ),
              const SizedBox(height: 10),
              buildInfoRow(
                theme,
                Icons.calendar_month,
                'Booked on: ${DateTimeFormatUtil().getFormattedAddedDateTime(appointment.bookingTime)}',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSpecializationTag(ColorScheme theme, String specialization) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: theme.primary,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Text(
        specialization,
        style: TextStyle(
          color: theme.onPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget buildInfoRow(ColorScheme theme, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(icon, color: theme.onSurface, size: 20),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              color: theme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildActionButton(
      ColorScheme theme, IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.primary,
        foregroundColor: theme.onPrimary,
      ),
      onPressed: onPressed,
    );
  }
}
