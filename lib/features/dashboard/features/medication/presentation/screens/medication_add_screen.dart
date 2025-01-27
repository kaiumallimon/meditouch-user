import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meditouch/common/push_notification/notification_service.dart';

import '../../../epharmacy/presentation/screens/load_medicine_from_prescription_screen.dart';
import '../../data/model/medication_model.dart';
import '../../data/repository/medication_db_helper.dart';
import '../../data/repository/medication_notification_service.dart';

class MedicationReminderAddPage extends StatefulWidget {
  const MedicationReminderAddPage({super.key});

  @override
  _MedicationReminderAddPageState createState() =>
      _MedicationReminderAddPageState();
}

class _MedicationReminderAddPageState extends State<MedicationReminderAddPage> {
  List<MedicineReminder> reminders = [];
  List<TextEditingController> medicineControllers = [];
  List<DateTime?> fromDates = [];
  List<DateTime?> toDates = [];
  List<TimeOfDay?> reminderTimes = [];

  @override
  void initState() {
    super.initState();
    _addMedicineFields(); // Initially add one set of fields
  }

  // Function to add a new set of input fields for medicine
  void _addMedicineFields() {
    setState(() {
      medicineControllers.add(TextEditingController());
      fromDates.add(null);
      toDates.add(null);
      reminderTimes.add(null);
    });
  }

  // Function to select a date
  Future<void> _selectDate(
      BuildContext context, bool isFromDate, int index) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        if (isFromDate) {
          fromDates[index] = pickedDate;
        } else {
          toDates[index] = pickedDate;
        }
      });
    }
  }

  // Function to select time
  Future<void> _selectTime(BuildContext context, int index) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        reminderTimes[index] = pickedTime;
      });
    }
  }

  void _saveReminders(BuildContext context) async {
    // A set to track unique reminder times
    Set<String> uniqueReminderTimes = {};

    for (int i = 0; i < medicineControllers.length; i++) {
      if (medicineControllers[i].text.isEmpty ||
          fromDates[i] == null ||
          toDates[i] == null ||
          reminderTimes[i] == null) {
        // Show error if any field is missing
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Please fill in all fields for each medicine')),
        );
        return;
      }

      // Create a unique key based on the reminder time and date range
      String uniqueKey =
          '${reminderTimes[i]!.hour}:${reminderTimes[i]!.minute}:${fromDates[i]}:${toDates[i]}';

      // Check if this unique key is already scheduled
      if (!uniqueReminderTimes.contains(uniqueKey)) {
        // If not scheduled, add it to the set
        uniqueReminderTimes.add(uniqueKey);

        // Create a new MedicineReminder object
        MedicineReminder reminder = MedicineReminder(
          id: generateUniqueId(),
          medicineName: medicineControllers[i].text,
          reminderTime: reminderTimes[i]!,
          fromDate: fromDates[i]!,
          toDate: toDates[i]!,
        );

        // Save the reminder to the database
        // insertReminder(reminder); // Assuming you have a method to insert into the database
        // MeditouchLocalNotifications().scheduleMedicineReminder(reminder); // Schedule the notification

        //save to local storage
        await MedicationDBHelper().insertReminder(reminder);

        DateTime time = DateTime(
          reminder.fromDate.year, // Extract year from fromDate
          reminder.fromDate.month, // Extract month from fromDate
          reminder.fromDate.day, // Extract day from fromDate
          reminder.reminderTime.hour, // Extract hour from reminderTime
          reminder.reminderTime.minute, // Extract minute from reminderTime
        );

        // NotificationService().scheduleNotification(
        //   notificationTime: TimeOfDay.fromDateTime(time),
        //   title: "Medication Reminder",
        //   body: "Dear user, It's time to take ${reminder.medicineName}!",
        //   startDate: reminder.fromDate,
        //   endDate: reminder.toDate,
        // );

        // MeditouchLocalNotifications().showNotification(
        //   id: 0,
        //   title: "TItle",
        //   body: "Body",
        //   payLoad: "payload"
        // );

        // Schedule the notification
        // MeditouchLocalNotifications().scheduleDailyNotification(time: reminder.reminderTime, title: "Medication Reminder", body: "Dear user, It's time to take ${reminder.medicineName}!", from: reminder.fromDate, to: reminder.toDate);
      }

      // Add the reminder to the local list (if you need it)
      setState(() {
        reminders.add(
          MedicineReminder(
            medicineName: medicineControllers[i].text,
            reminderTime: reminderTimes[i]!,
            fromDate: fromDates[i]!,
            toDate: toDates[i]!,
          ),
        );
      });
    }

    // Clear the inputs after saving
    medicineControllers.clear();
    fromDates.clear();
    toDates.clear();
    reminderTimes.clear();
    _addMedicineFields();

    Navigator.pop(context);
  }

  // Future<void> _requestExactAlarmPermission() async {
  //   if (await Permission.scheduleExactAlarm.request().isGranted) {
  //     print('Exact alarm permission granted.');
  //   } else {
  //     print('Exact alarm permission denied.');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Medication Reminder'),
        actions: [
          IconButton.filled(
            onPressed: () {
              _saveReminders(context);
            },
            icon: Icon(Icons.save,color: theme.onPrimary,),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            

            // Dynamic list of medicine input fields
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: medicineControllers.length,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Medicine ${index + 1}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Medicine name input field
                                  CustomTextField(
                                    height: 50,
                                    width: double.infinity,
                                    bgColor: theme.primary.withOpacity(.1),
                                    fgColor: theme.onSurface,
                                    hint: "Medicine name",
                                    controller: medicineControllers[index],
                                  ),
                                  SizedBox(height: 10),

                                  // Date pickers for selecting from and to dates
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // TextButton(
                                      //   onPressed: () => _selectDate(context, true, index),
                                      //   child: Text(fromDates[index] == null
                                      //       ? 'Select Start Date'
                                      //       : DateFormat('yyyy-MM-dd').format(fromDates[index]!)),
                                      // ),
                                      Expanded(
                                          child: SizedBox(
                                        height: 45,
                                        child: ElevatedButton(
                                          onPressed: () =>
                                              _selectDate(context, true, index),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: theme.secondary,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: Text(
                                            fromDates[index] == null
                                                ? 'From'
                                                : DateFormat('yyyy-MM-dd')
                                                    .format(fromDates[index]!),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )),
                                      const SizedBox(width: 10),

                                      Expanded(
                                          child: SizedBox(
                                        height: 45,
                                        child: ElevatedButton(
                                          onPressed: () => _selectDate(
                                              context, false, index),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: theme.secondary,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: Text(
                                            toDates[index] == null
                                                ? 'To'
                                                : DateFormat('yyyy-MM-dd')
                                                    .format(toDates[index]!),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                  SizedBox(height: 10),

                                  // Time picker for selecting reminder time
                                  // TextButton(
                                  //   onPressed: () => _selectTime(context, index),
                                  //   child: Text(reminderTimes[index] == null
                                  //       ? 'Select Reminder Time'
                                  //       : reminderTimes[index]!.format(context)),
                                  // ),
                                  // Divider(),

                                  SizedBox(
                                    height: 45,
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () =>
                                          _selectTime(context, index),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            CupertinoColors.activeGreen,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text(reminderTimes[index] == null
                                          ? 'Reminder Time'
                                          : reminderTimes[index]!
                                              .format(context)),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Delete button to remove the medicine
                            const SizedBox(width: 10),

                            IconButton(
                              icon: Icon(Icons.delete),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.error,
                                foregroundColor: theme.onError,
                              ),
                              onPressed: () {
                                setState(() {
                                  medicineControllers.removeAt(index);
                                  fromDates.removeAt(index);
                                  toDates.removeAt(index);
                                  reminderTimes.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Button to add another medicine
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: theme.primary.withOpacity(.1),
              ),
              child: Center(
                child: ElevatedButton(
                  onPressed: _addMedicineFields,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.secondary,
                    foregroundColor: theme.onSecondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Add Another Medicine'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch; // Current timestamp as int
  }
}
