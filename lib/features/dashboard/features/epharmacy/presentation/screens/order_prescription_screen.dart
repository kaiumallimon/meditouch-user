import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meditouch/app/app_exporter.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/data/model/combined_medicine.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/data/model/medicine_model.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/data/repository/epharmacy_repository.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../../../../common/utils/datetime_format.dart';
import '../../../../../../common/widgets/custom_loading_animation.dart';
import '../../../doctors/data/models/appointment_model.dart';
import '../../../doctors/data/models/doctor_model.dart';
import '../../../prescription/data/repository/prescription_repository.dart';
import 'load_medicine_from_prescription_screen.dart';

class AutomaticOrderFromPrescription extends StatelessWidget {
  const AutomaticOrderFromPrescription({super.key});

  @override
  Widget build(BuildContext context) {
    // get theme:
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: theme.surfaceContainer,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Order from Prescription',
        ),
        backgroundColor: theme.surfaceContainer,

      ),

      body: SafeArea(child: Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Select appointment to order from prescription:",
                  style: TextStyle(color: theme.onSurface.withOpacity(.5))),

              const SizedBox(height: 20),

              Expanded(
                child: FutureBuilder(
                  future: HiveRepository().getUserInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CustomLoadingAnimation(
                              size: 25, color: theme.primary));
                    }

                    if (snapshot.hasError) {
                      return Center(
                          child: Text('Error loading appointments',
                              style: TextStyle(color: theme.error)));
                    }

                    final userId = snapshot.data!['id'];

                    return FutureBuilder<List<AppointmentModel>>(
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
                        });
                  }
                ),
              )
            ],
          ),)),
    );
  }
}

void hideCustomLoadingDialog(BuildContext context) {
  Navigator.of(context).pop();
}

void showCustomAlert(BuildContext context, String message, Color bgColor, Color fgColor) {
  QuickAlert.show(context: context, type: QuickAlertType.error, text: message,barrierDismissible: false);
}

void showCustomLoadingDialog(BuildContext context) {
  QuickAlert.show(context: context, type: QuickAlertType.loading,barrierDismissible: false);
}


Widget buildAppointmentCard(
    BuildContext context, AppointmentModel appointment, ColorScheme theme) {
  final doctorDetails = DoctorModel.fromJson(
    appointment.doctorDetails,
    appointment.doctorId,
  );

  return GestureDetector(
    onTap: () async{
      showCustomLoadingDialog(context);
      // Navigate to the prescription details screen
      final  prescription = await PrescriptionRepository().getRemotePrescription(appointment.appointmentId);

      if(prescription!=null){
        final List<MedicineModel> medicines = prescription.medicines;

        List<CombinedMedicine> combinedMedicines = [];

        for(var medicine in medicines){
          String medicineName = medicine.name;
          List<Medicine>? searchResults = await EpharmacyRepository().searchMedicineForAutomaticOrder(medicineName);


          String temporarySlug = "${medicine.name}${medicine.strength}".replaceAll(" ", "-");
          print("Temporary slug: $temporarySlug");

          if (searchResults != null &&
              searchResults.isNotEmpty) {
            // Combine the prescription data with search results
            var searchData =
            searchResults.firstWhere(
                    (med) =>
                (med.medicineName ==
                    medicineName ||
                    med.slug.contains(temporarySlug)||
                    med.strength.contains(medicine.strength))
                    ,
                orElse: () => Medicine
                    .defaultMedicine());

            // Add the combined data to the list
            combinedMedicines
                .add(CombinedMedicine(
              prescriptionName:
              medicineName,
              prescriptionStrength:
              medicine.strength,
              searchResult: searchData,
            ));
          }
        }


        hideCustomLoadingDialog(context);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CombinedMedicinePage(
                  combinedMedicines:
                  combinedMedicines,
                ),
          ),
        );
      }else{
        hideCustomLoadingDialog(context);
        showCustomAlert(context, "No prescription found", theme.error, theme.onError);
      }

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
