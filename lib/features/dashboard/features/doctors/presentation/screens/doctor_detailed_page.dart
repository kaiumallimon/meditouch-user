import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:meditouch/app/app_exporter.dart';
import 'package:meditouch/common/widgets/custom_loading_animation.dart';
import 'package:meditouch/features/dashboard/features/doctors/data/models/doctor_model.dart';
import '../../data/repository/detailed_doctor_repository.dart';
import '../../logics/detailed_doctor_controller.dart';
import '../widgets/build_rating_stars.dart';
import 'appointment_book_screen.dart';

part './parts/doctor_info_card.dart';

// doctor_detailed_page.dart

class DoctorDetailedPage extends StatelessWidget {
  const DoctorDetailedPage({super.key, required this.doctor});

  final DoctorModel doctor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    Get.put(() => DetailedDoctorController(doctor.id,
        repository: DetailedDoctorRepository()));

    return SafeArea(
      child: Scaffold(
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
        body: buildDetailedDoctorBody(context, theme, doctor),
      ),
    );
  }
}

Widget buildDetailedDoctorBody(
    BuildContext context, ColorScheme theme, DoctorModel doctor) {
  return SingleChildScrollView(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Doctor personal details card
        buildDoctorInfoCard(theme, doctor),

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
  // print(doctor.timeSlots);

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
                      // Filter available time slots
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
                            for (final slot in entry.value)
                              if (slot['isBooked'] == false)
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AppointmentBookScreen(
                                          date: entry.key,
                                          timeSlotIndex:
                                              entry.value.indexOf(slot),
                                          doctor: doctor,
                                        ),
                                      ),
                                    );
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
                                ),
                          ],
                        ),
                  ],
                ),
              );
      });
}
