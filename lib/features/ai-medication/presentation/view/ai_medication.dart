import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditouch/common/widgets/custom_loading_animation.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/data/repository/gemini_repository.dart';
import 'package:meditouch/features/dashboard/features/medication/data/model/medication_model.dart';
import 'package:meditouch/features/dashboard/features/medication/data/repository/medication_db_helper.dart';

class AiMedication extends StatelessWidget {
  const AiMedication({super.key, required this.medicineImage});

  final XFile medicineImage;

  @override
  Widget build(BuildContext context) {
    // get theme
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: theme.surfaceContainer,
      appBar: AppBar(
        backgroundColor: theme.surfaceContainer,
        elevation: 0,
        surfaceTintColor: theme.surfaceContainer,
        title: const Text('AI Medication'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: FutureBuilder(
              future: GeminiRepository().analyzeMedicineImage(
                File(medicineImage!.path),
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CustomLoadingAnimation(
                    size: 20,
                    color: theme.primary,
                  ));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final result = snapshot.data!;

                  if (result['status'] == false) {
                    return Center(child: Text('Error: ${result['message']}'));
                  }

                  final response = result['response'];

                  return FutureBuilder<List<MedicineReminder>>(
                      future: MedicationDBHelper().fetchReminders(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: CustomLoadingAnimation(
                            size: 20,
                            color: theme.primary,
                          ));
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }

                        final List<MedicineReminder> reminders = snapshot.data!;

                        bool containsMedicine = reminders.any((element) =>
                            element.medicineName.toLowerCase() ==
                            "${response['name']} ${response['strength']}"
                                .toLowerCase());

                        MedicineReminder? reminder;

                        if (containsMedicine) {
                          reminder = reminders.firstWhere((element) =>
                              element.medicineName.toLowerCase() ==
                              "${response['name']} ${response['strength']}"
                                  .toLowerCase());
                        }

                        return Center(
                          child: Column(
                            spacing: 10,
                            children: [
                              Container(
                                height: 200,
                                width: double.infinity,
                                child: Image.file(
                                  File(medicineImage!.path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Center(
                                child: Text(
                                  '${response['name']} ${response['strength']}',
                                  style: TextStyle(
                                    color: theme.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: theme.primaryContainer,
                                    borderRadius: BorderRadius.circular(10)),
                                child: containsMedicine
                                    ? Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('From:',
                                                  style: TextStyle(
                                                      color: theme.primary,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  reminder!.fromDate
                                                      .toString()
                                                      .split(" ")[0],
                                                  style: TextStyle(
                                                      color: theme.primary,
                                                      fontSize: 16)),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('To:',
                                                  style: TextStyle(
                                                      color: theme.primary,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  reminder.toDate
                                                      .toString()
                                                      .split(" ")[0],
                                                  style: TextStyle(
                                                      color: theme.primary,
                                                      fontSize: 16)),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Days Remaining:',
                                                  style: TextStyle(
                                                      color: theme.primary,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  calculateDaysRemaining(
                                                      DateTime.now(),
                                                      reminder.toDate),
                                                  style: TextStyle(
                                                      color: theme.primary,
                                                      fontSize: 16)),
                                            ],
                                          ),


                                          const SizedBox(height: 10),

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Time to take:',
                                                  style: TextStyle(
                                                      color: theme.primary,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  formatTimeOfDay(reminder.reminderTime),
                                                  style: TextStyle(
                                                      color: theme.primary,
                                                      fontSize: 16)),
                                            ],
                                          ),
                                        ],
                                      )
                                    : Center(
                                        child: Text(
                                            'No reminders found for this medicine',
                                            style: TextStyle(
                                                color: theme.error,
                                                fontSize: 16)),
                                      ),
                              )
                            ],
                          ),
                        );
                      });
                }
              }),
        ),
      ),
    );
  }
}

String calculateDaysRemaining(DateTime startDate, DateTime endDate) {
  final difference = endDate.difference(startDate).inDays;
  return difference.toString();
}


String formatTimeOfDay(TimeOfDay time) {
  final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod; // Convert 0 to 12 for 12-hour format
  final minute = time.minute.toString().padLeft(2, '0'); // Add leading zero if needed
  final period = time.period == DayPeriod.am ? 'AM' : 'PM'; // Determine AM/PM
  return '$hour:$minute $period';
}