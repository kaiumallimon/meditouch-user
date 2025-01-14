import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:meditouch/common/repository/hive_repository.dart';
import 'package:meditouch/common/utils/datetime_format.dart';
import 'package:meditouch/common/widgets/custom_loading_animation.dart';
import 'package:meditouch/features/dashboard/features/appointments/data/repository/appointment_repository.dart';
import 'package:meditouch/features/dashboard/features/appointments/logics/appointment_bloc.dart';
import 'package:meditouch/features/dashboard/features/doctors/data/models/appointment_model.dart';
import 'package:meditouch/features/dashboard/features/doctors/data/models/doctor_model.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // get theme:
    final theme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text('Appointments',
              style: TextStyle(
                  color: theme.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          // chips for 'upcoming' and 'past' appointments
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 10,
            children: [
              _buildAppointmentChip(context, 'Upcoming/Current', 'upcoming'),
              _buildAppointmentChip(context, 'Past', 'past'),
            ],
          ),

          const SizedBox(
            height: 20,
          ),
          buildAppointmentsTab(context, theme)
        ],
      ),
    );
  }

  Widget buildAppointmentsTab(BuildContext context, ColorScheme theme) {
    return Expanded(
      child: FutureBuilder(
        future: HiveRepository().getUserInfo(),
        builder: (context, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return CustomLoadingAnimation(size: 25, color: theme.primary);
          }

          if (futureSnapshot.hasError || !futureSnapshot.hasData) {
            return const Center(child: Text('Failed to load user info'));
          }

          final user = futureSnapshot.data!;

          return StreamBuilder(
            stream: AppointmentRepository().getAppointments(user['id']),
            builder: (context, streamSnapshot) {
              if (streamSnapshot.connectionState == ConnectionState.waiting) {
                return CustomLoadingAnimation(size: 25, color: theme.primary);
              }

              if (streamSnapshot.hasError ||
                  !streamSnapshot.hasData ||
                  streamSnapshot.data!['status'] == false) {
                return const Center(child: Text('An error occurred!'));
              }

              final allAppointments = streamSnapshot.data!['data'];
              final upcomingAppointments = (allAppointments['upcoming']
                  as List<AppointmentModel>)
                ..sort((a, b) => DateTime.parse(b.bookingTime)
                    .compareTo(DateTime.parse(a.bookingTime)));
              final pastAppointments = (allAppointments['past']
                  as List<AppointmentModel>)
                ..sort((a, b) => DateTime.parse(b.bookingTime)
                    .compareTo(DateTime.parse(a.bookingTime)));

              return BlocBuilder<AppointmentCubit, String>(
                builder: (context, state) {
                  final appointments = state == 'upcoming'
                      ? upcomingAppointments
                      : pastAppointments;

                  return appointments.isEmpty
                      ? const Center(child: Text('No appointments found'))
                      : ListView.builder(
                          itemCount: appointments.length,
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return buildAppointmentCard(
                              context,
                              appointments[index],
                              theme,
                            );
                          },
                        );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget buildAppointmentCard(
      BuildContext context, AppointmentModel appointment, ColorScheme theme) {
    final doctorDetails = DoctorModel.fromJson(
      appointment.doctorDetails,
      appointment.doctorId,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 60),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: theme.primary.withOpacity(.1),
            blurRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40), // Space for the avatar
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
            Positioned(
              top: -60,
              left: 20,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: theme.surface,
                backgroundImage:
                    CachedNetworkImageProvider(doctorDetails.imageUrl),
              ),
            ),
            if (appointment.videoCallId != null)
              Positioned(
                right: 60,
                top: -10,
                child: buildActionButton(
                  theme,
                  CupertinoIcons.video_camera,
                  () {
                    // Join meeting logic
                  },
                ),
              ),
            Positioned(
              right: 10,
              top: -10,
              child: buildActionButton(
                theme,
                CupertinoIcons.chat_bubble,
                () {
                  // Message logic
                },
              ),
            ),
          ],
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

  Widget _buildAppointmentChip(BuildContext context, String label, String tab) {
    final theme = Theme.of(context).colorScheme;

    return BlocBuilder<AppointmentCubit, String>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            // change the tab
            context.read<AppointmentCubit>().changeTab(tab);
          },
          child: Chip(
            elevation: 6,
            side: BorderSide(
              color: theme.primary.withOpacity(.2),
            ),
            label: Text(
              label,
              style: TextStyle(
                  color: state == tab ? theme.onPrimary : theme.onSurface,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: state == tab ? theme.primary : theme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            shadowColor: theme.primary.withOpacity(0.4),
          ),
        );
      },
    );
  }
}
