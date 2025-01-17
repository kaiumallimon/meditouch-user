import 'package:flutter/material.dart';
import 'package:meditouch/common/widgets/custom_loading_animation.dart';
import 'package:meditouch/features/dashboard/features/doctors/data/models/appointment_model.dart';
import 'package:meditouch/features/dashboard/features/prescription/data/repository/prescription_repository.dart';

class DetailedRemotePrescriptionView extends StatelessWidget {
  const DetailedRemotePrescriptionView({super.key, required this.appointment});

  final AppointmentModel appointment;

  @override
  Widget build(BuildContext context) {
    // get theme:
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.surfaceContainer,
      appBar: AppBar(
        backgroundColor: theme.surfaceContainer,
        title: Text('Remote Prescription Details',
            style: TextStyle(color: theme.onSurface, fontSize: 18)),
      ),
      body: SafeArea(
          child: FutureBuilder(
              future: PrescriptionRepository()
                  .getRemotePrescription(appointment.appointmentId),
              builder: (context, prescriptionSnapshot) {
                if (prescriptionSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                      child: CustomLoadingAnimation(
                          size: 25, color: theme.primary));
                }

                if (prescriptionSnapshot.hasError) {
                  return Center(
                      child: Text(
                          'An error occurred while fetching prescription data'));
                }

                if (prescriptionSnapshot.data == null) {
                  return Center(child: Text('No prescription data found'));
                }

                final prescription = prescriptionSnapshot.data;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 15,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: theme.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text('Prescription Details',
                              style: TextStyle(
                                  color: theme.onSurface,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: theme.secondary.withOpacity(.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                              '${appointment.appointmentDate} at ${appointment.appointmentTimeSlot}',
                              style: TextStyle(
                                  color: theme.onSurface,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: theme.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                spacing: 5,
                                children: [
                                  Text('Patient Details',
                                      style: TextStyle(
                                          color: theme.onPrimary,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 0),
                                  Text(
                                      'Name: ${appointment.patientDetails['name']}',
                                      style: TextStyle(
                                          color: theme.onPrimary,
                                          fontSize: 12)),
                                  Text(
                                      'Age: ${calculateAgeInYears(appointment.patientDetails['dob']) ?? 'N/A'}',
                                      style: TextStyle(
                                          color: theme.onPrimary,
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: theme.secondary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                spacing: 5,
                                children: [
                                  Text('Doctor Details',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 0),
                                  Text(
                                      'Name: ${appointment.doctorDetails['name']}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12)),
                                  Text(
                                      'Specialization: ${appointment.doctorDetails['specialization']}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12)),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),

                      // Display medicines

                      Expanded(
                          child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            Text('Medicines',
                                style: TextStyle(
                                    color: theme.onSurface,
                                    fontWeight: FontWeight.bold)),
                            ...prescription!.medicines
                                .map((medicine) => Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: theme.primaryContainer,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        spacing: 5,
                                        children: [
                                          Text('Name: ${medicine.name}',
                                              style: TextStyle(
                                                  color: theme.onSurface,
                                                  fontSize: 12)),
                                          Text('Strength: ${medicine.strength}',
                                              style: TextStyle(
                                                  color: theme.onSurface,
                                                  fontSize: 12)),
                                          Text('Days: ${medicine.days}',
                                              style: TextStyle(
                                                  color: theme.onSurface,
                                                  fontSize: 12)),
                                          Text(
                                              'Doses per day: ${medicine.dosesPerDay}',
                                              style: TextStyle(
                                                  color: theme.onSurface,
                                                  fontSize: 12)),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ],
                        ),
                      ))
                    ],
                  ),
                );
              })),
    );
  }
}

String calculateAgeInYears(String dobISOString) {
  final dob = DateTime.parse(dobISOString);
  final now = DateTime.now();
  var age = now.year - dob.year;
  if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
    age--;
  }
  return "$age years";
}
