import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:meditouch/app/app_exporter.dart';
import 'package:meditouch/common/widgets/custom_loading_animation.dart';
import 'package:meditouch/features/dashboard/features/doctors/data/models/doctor_model.dart';
import 'package:meditouch/features/dashboard/features/family-members/data/repository/family_member_repository.dart';
import '../../data/repository/detailed_doctor_repository.dart';
import '../../logics/detailed_doctor_controller.dart';
import '../widgets/build_rating_stars.dart';
import 'appointment_book_screen.dart';

part './parts/doctor_info_card.dart';

// doctor_detailed_page.dart

class DoctorDetailedPage extends StatelessWidget {
  const DoctorDetailedPage(
      {super.key, required this.doctor, required this.rating});

  final DoctorModel doctor;
  final double rating;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    Get.put(() => DetailedDoctorController(doctor.id,
        repository: DetailedDoctorRepository()));

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
          child: buildDetailedDoctorBody(context, theme, doctor, rating)),
    );
  }
}

Widget buildDetailedDoctorBody(BuildContext context, ColorScheme theme,
    DoctorModel doctor, double rating) {
  return SingleChildScrollView(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Doctor personal details card
        buildDoctorInfoCard(theme, doctor, rating),

        const SizedBox(height: 15),

        Text('Available Time Slots',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.primary,
                fontSize: 17)),
        const SizedBox(height: 15),

        /// Doctor's time slots card
        ///
        buildDoctorTimeSlotsCard(context, theme, doctor.id),
      ],
    ),
  );
}

Widget buildDoctorTimeSlotsCard(
    BuildContext context, ColorScheme theme, String doctorId) {
  return StreamBuilder<Map<String, dynamic>>(
    stream: DetailedDoctorRepository().getDoctorDetails(doctorId),
    builder: (context, snapshot) {
      if (snapshot.hasError ||
          !snapshot.hasData ||
          snapshot.data!['status'] == false) {
        return const Center(
          child: Text('An error occurred while fetching doctor details'),
        );
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CustomLoadingAnimation(
            size: 30,
            color: theme.primary,
          ),
        );
      }

      final DoctorModel doctor = snapshot.data!['doctor'];

      doctor.timeSlots.forEach((key, value) {
        // Parse the date from the key
        final slotDate =
            DateTime.parse(key); // Assuming the key is in "YYYY-MM-DD" format
        final now = DateTime.now();

        // Remove any past time slots from the value list
        value.removeWhere((slot) {
          final timeRange =
              slot['time'].split(" - ")[1].trim(); // Get the end time
          final timeParts = timeRange.split(" ");
          final hourMinute = timeParts[0].split(":");
          final hour = int.parse(hourMinute[0]);
          final minute = int.parse(hourMinute[1]);
          final amPm = timeParts[1].toUpperCase();

          // Adjust hour for AM/PM format
          int adjustedHour = hour;
          if (amPm == "PM" && hour != 12) {
            adjustedHour += 12;
          } else if (amPm == "AM" && hour == 12) {
            adjustedHour = 0;
          }

          // Create DateTime for the slot's end time
          final slotTime = DateTime(
            slotDate.year,
            slotDate.month,
            slotDate.day,
            adjustedHour,
            minute,
            0,
          );

          // Return true if the slot time is before now, causing it to be removed
          return slotTime.isBefore(now) || slot['isBooked'] == true;
        });
      });

      return doctor.timeSlots.isEmpty
          ? const Center(
              child: Text(
                'No time slots available at the moment',
              ),
            )
          : Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: theme.primary.withOpacity(.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final entry in doctor.timeSlots.entries)
                    if (entry.value.any((slot) => slot['isBooked'] == false))
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.primary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true, // Prevents overflow
                            physics:
                                NeverScrollableScrollPhysics(), // Disable scrolling
                            itemCount: entry.value
                                .where((slot) => slot['isBooked'] == false)
                                .toList()
                                .length,
                            itemBuilder: (context, index) {
                              final availableSlots = entry.value
                                  .where((slot) => slot['isBooked'] == false)
                                  .toList();

                              // Sorting the slots based on start time
                              final sortedSlots = List.from(availableSlots)
                                ..sort((a, b) {
                                  // Extract and convert the start time from the string
                                  DateTime parseTime(String time) {
                                    final timePart =
                                        time.split(" - ")[0].trim();

                                    final timeParts = timePart.split(" ");
                                    final hourMinute = timeParts[0].split(":");
                                    final hour = int.parse(hourMinute[0]);
                                    final minute = int.parse(hourMinute[1]);
                                    final amPm = timeParts[1].toUpperCase();

                                    // Adjust hour for AM/PM format
                                    int adjustedHour = hour;
                                    if (amPm == "PM" && hour != 12) {
                                      adjustedHour += 12;
                                    } else if (amPm == "AM" && hour == 12) {
                                      adjustedHour = 0;
                                    }

                                    return DateTime(
                                      2025,
                                      1,
                                      1,
                                      adjustedHour,
                                      minute,
                                      0,
                                    );
                                  }

                                  try {
                                    return parseTime(a['time'])
                                        .compareTo(parseTime(b['time']));
                                  } catch (e) {
                                    print("Error parsing time: $e");
                                    return 0; // Default comparison if parsing fails
                                  }
                                });

                              // filter past appointments
                              // params: [date, from-to]
                              final now = DateTime.now();

                              // sortedSlots.removeWhere((slot) {
                              //   final time = slot['time'].split(" - ")[1].trim();
                              //   print(time);
                              //   final timeParts = time.split(" ");
                              //   final hourMinute = timeParts[0].split(":");
                              //   final hour = int.parse(hourMinute[0]);
                              //   final minute = int.parse(hourMinute[1]);
                              //   final amPm = timeParts[1].toUpperCase();
                              //
                              //   // Adjust hour for AM/PM format
                              //   int adjustedHour = hour;
                              //   if (amPm == "PM" && hour != 12) {
                              //     adjustedHour += 12;
                              //   } else if (amPm == "AM" && hour == 12) {
                              //     adjustedHour = 0;
                              //   }
                              //
                              //   print(" Adjusted hour: ${adjustedHour}");
                              //
                              //   final slotTime = DateTime(
                              //     now.year,
                              //     now.month,
                              //     now.day,
                              //     adjustedHour,
                              //     minute,
                              //     0,
                              //   );
                              //
                              //
                              //
                              //   return slotTime.isBefore(now);
                              // });

                              final slot = sortedSlots[index];

                              return GestureDetector(
                                onTap: () {
                                  // move towards the middleware to select
                                  // family member and then book appointment
                                  showBottomSheet(context, theme, entry.key,
                                      entry.value.indexOf(slot), doctor);

                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         AppointmentBookScreen(
                                  //       date: entry.key,
                                  //       timeSlotIndex:
                                  //           entry.value.indexOf(slot),
                                  //       doctor: doctor,
                                  //     ),
                                  //   ),
                                  // );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    color: theme.surfaceContainer,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      slot['time'],
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: theme.primary.withOpacity(.5),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                ],
              ),
            );
    },
  );
}

void showBottomSheet(BuildContext context, ColorScheme theme, String date,
    int timeslotIndex, DoctorModel doctor) {
  showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) => Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              color: theme.surfaceContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<Map<String, dynamic>?>(
                future: HiveRepository().getUserInfo(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CustomLoadingAnimation(
                        size: 20,
                        color: theme.primary,
                      ),
                    );
                  }

                  if (snapshot.hasError || !snapshot.hasData) {
                    return const Center(
                      child:
                          Text('An error occurred while fetching user details'),
                    );
                  }

                  final user = snapshot.data!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select for whom you want to book the appointment',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AppointmentBookScreen(
                                date: date,
                                timeSlotIndex: timeslotIndex,
                                doctor: doctor,
                                user: user,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: theme.primaryContainer,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundImage: CachedNetworkImageProvider(
                                user['image'],
                              ),
                            ),
                            title: const Text(
                              "For Me",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              user['name'],
                              style: TextStyle(
                                color: theme.primary,
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: theme.primary.withOpacity(.5),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                          child: StreamBuilder(
                              stream: FamilyMemberRepository()
                                  .getFamilyMemberStream(user['id']),
                              builder: (context, familySnapshot) {
                                if (familySnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CustomLoadingAnimation(
                                      size: 20,
                                      color: theme.primary,
                                    ),
                                  );
                                }

                                if (familySnapshot.hasError ||
                                    !familySnapshot.hasData) {
                                  return const Center(
                                    child: Text(
                                        'An error occurred while fetching family members'),
                                  );
                                }

                                final data = familySnapshot.data!;

                                final familyMembers = data.familyMembers;

                                return ListView.builder(
                                  itemCount: familyMembers.length,
                                  itemBuilder: (context, index) {
                                    final member = familyMembers[index];

                                    final membersMap = member.toMap();
                                    membersMap['id'] = user['id'];

                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AppointmentBookScreen(
                                              date: date,
                                              timeSlotIndex: timeslotIndex,
                                              doctor: doctor,
                                              user: membersMap,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        decoration: BoxDecoration(
                                          color: theme.primaryContainer,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            radius: 20,
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    member.image!),
                                          ),
                                          title: Text(
                                            member.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(
                                            member.relationShip,
                                            style: TextStyle(
                                              color: theme.primary,
                                            ),
                                          ),
                                          trailing: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 16,
                                            color:
                                                theme.primary.withOpacity(.5),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }))
                    ],
                  );
                }),
          ));
}
