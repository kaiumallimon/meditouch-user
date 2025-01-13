import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:meditouch/app/app_exporter.dart';
import 'package:meditouch/features/dashboard/features/doctors/data/models/doctor_model.dart';
import '../widgets/build_rating_stars.dart';

part './parts/doctor_info_card.dart';

// doctor_detailed_page.dart

class DoctorDetailedPage extends StatelessWidget {
  const DoctorDetailedPage({super.key, required this.doctor});

  final DoctorModel doctor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

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

        // Appointment details card
        doctor.timeSlots.isNotEmpty
            ? DoctorAppointmentDetailsCard(theme: theme, doctor: doctor)
            : const Center(
                child: Text(
                  "No available appointments at this time.",
                  style: TextStyle(fontSize: 16),
                ),
              ),
      ],
    ),
  );
}

class DoctorAppointmentDetailsCard extends StatefulWidget {
  const DoctorAppointmentDetailsCard(
      {super.key, required this.theme, required this.doctor});

  final ColorScheme theme;
  final DoctorModel doctor;

  @override
  State<DoctorAppointmentDetailsCard> createState() =>
      _DoctorAppointmentDetailsCardState();
}

class _DoctorAppointmentDetailsCardState
    extends State<DoctorAppointmentDetailsCard> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> timeSlots = Map.from(widget.doctor.timeSlots);

    // Filter out dates where all time slots have passed
    timeSlots.removeWhere((key, value) {
      final date = DateTime.parse(key);
      final now = DateTime.now();

      // Check if all time slots for the date are in the past
      return value.every((timeRange) {
        final startTimeString = timeRange.split(" - ")[0];
        final parsedTime = _parseTime(startTimeString, date);
        return parsedTime.isBefore(now);
      });
    });

    if (timeSlots.isEmpty) {
      return Center(
        child: Text(
          "No available appointments.",
          style: TextStyle(
            fontSize: 16,
            color: widget.theme.onSurface.withOpacity(0.7),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Available Appointments",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: widget.theme.primary,
            ),
          ),
          const SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: timeSlots.length,
            separatorBuilder: (_, __) => const SizedBox(height: 15),
            itemBuilder: (context, index) {
              final date = timeSlots.keys.elementAt(index);
              final times = timeSlots[date];

              return AppointmentDateCard(
                date: date,
                times: times,
                theme: widget.theme,
              );
            },
          ),
        ],
      ),
    );
  }

  // Helper method to parse time strings
  DateTime _parseTime(String timeString, DateTime date) {
    final format = DateFormat("h:mm a");
    final time = format.parse(timeString); // Parse time
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}

class AppointmentDateCard extends StatelessWidget {
  const AppointmentDateCard({
    super.key,
    required this.date,
    required this.times,
    required this.theme,
  });

  final String date;
  final List<dynamic> times;
  final ColorScheme theme;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: theme.primaryContainer,
      shadowColor: theme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.yMMMMd().format(DateTime.parse(date)),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.primary,
              ),
            ),
            const SizedBox(height: 10),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: times.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: theme.onSurface.withOpacity(0.2)),
              itemBuilder: (context, index) {
                final time = times[index];
                return ListTile(
                  title: Text(
                    time,
                    style: TextStyle(fontSize: 16, color: theme.onSurface),
                  ),
                  onTap: () {
                    // Navigate to the appointment booking page
                  },
                  trailing: Icon(Icons.arrow_forward_ios,
                      size: 16, color: theme.onSurface),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
