import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meditouch/features/dashboard/features/appointments/data/repository/appointment_repository.dart';
import 'package:meditouch/features/dashboard/features/doctors/data/models/appointment_model.dart';
import 'package:meditouch/features/dashboard/features/doctors/data/repository/appointment_book_repository.dart';
import 'package:r_icon_pro/r_icon_pro.dart';

import '../../../../../navigation/logics/navigation_cubit.dart';

Widget buildAppointmentBox(ColorScheme theme, int count, String userId) {
    return BlocBuilder<NavigationCubit, int>(builder: (context, state) {
      return GestureDetector(
        onTap: () {
          context.read<NavigationCubit>().switchTo(2);
        },
        child: Container(
          decoration: BoxDecoration(
            color: theme.primary,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        RIcon.Calendar,
                        color: theme.onPrimary,
                        size: 30,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Appointments',
                        style: TextStyle(
                          fontSize: 15,
                          color: theme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          StreamBuilder<Map<String,dynamic>>(
                            stream: AppointmentRepository().getAppointments(userId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Text(
                                  "Loading...",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: theme.onPrimary.withOpacity(0.7),
                                    height: 1,
                                  ),
                                );
                              }

                              if (snapshot.hasError) {
                                return Text(
                                  "Error loading appointments",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: theme.onPrimary.withOpacity(0.7),
                                    height: 1,
                                  ),
                                );
                              }

                              if (snapshot.data == null || snapshot.data!.isEmpty) {
                                return Text(
                                  "You have no upcoming appointments",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: theme.onPrimary.withOpacity(0.7),
                                    height: 1,
                                  ),
                                );
                              }


                              final data = snapshot.data!['data'];
                              final appointments = data['upcoming'] as List<AppointmentModel>;


                              // 'data': {
                              // 'upcoming': upcomingAppointments,
                              // 'past': pastAppointments,
                              // },

                              return Text(
                                "You have ${appointments.length} upcoming appointments",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: theme.onPrimary.withOpacity(0.7),
                                  height: 1,
                                ),
                              );
                            }
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  FontAwesomeIcons.chevronRight,
                  color: theme.onPrimary.withOpacity(0.7),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }