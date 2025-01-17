import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:hive/hive.dart';
import 'package:meditouch/common/utils/datetime_format.dart';
import 'package:quickalert/quickalert.dart';
import 'package:weekly_date_picker/weekly_date_picker.dart';
import '../../../epharmacy/presentation/screens/load_medicine_from_prescription_screen.dart';

import '../../data/model/medication_model.dart';
import '../../data/repository/medication_db_helper.dart';
import 'medication_add_screen.dart';


class MedicationReminderViewPage extends StatefulWidget {
  const MedicationReminderViewPage({super.key});

  @override
  _MedicationReminderViewPageState createState() =>
      _MedicationReminderViewPageState();
}

class _MedicationReminderViewPageState
    extends State<MedicationReminderViewPage> {
  late Stream<List<MedicineReminder>> remindersStream; // Declare the stream
  List<MedicineReminder> reminders = [];
  DateTime selectedDate = DateTime.now(); // Selected date initialized to today

  @override
  void initState() {
    super.initState();
    remindersStream =
        MedicationDBHelper().remindersStream; // Initialize the stream
    _loadReminders();
  }

  // Load reminders from SQLite database
  void _loadReminders() async {
    // Fetch the initial list of reminders
    reminders = await MedicationDBHelper().fetchReminders();
    setState(() {}); // Update state with the fetched reminders

    // Listen to the stream for reminders updates
    remindersStream.listen((data) {
      setState(() {
        reminders =
            data; // Update the reminders list when the stream emits new data
      });
    });
  }

  // Get reminders for the selected date
  List<MedicineReminder> _getRemindersForSelectedDate() {
    return reminders.where((reminder) {
      final fromDate = reminder.fromDate;
      final toDate =
          reminder.toDate; // Assuming toDate is available in the model

      return (fromDate.isBefore(selectedDate.add(Duration(days: 1))) &&
          toDate.isAfter(selectedDate.subtract(Duration(days: 1))));
    }).toList();
  }

  // Group reminders by their reminder time
  Map<String, List<MedicineReminder>> _groupRemindersByTime() {
    final remindersForSelectedDate = _getRemindersForSelectedDate();
    final Map<String, List<MedicineReminder>> groupedReminders = {};

    for (var reminder in remindersForSelectedDate) {
      final formattedTime = formatTime(reminder.reminderTime);
      if (groupedReminders[formattedTime] == null) {
        groupedReminders[formattedTime] = [];
      }
      groupedReminders[formattedTime]!.add(reminder);
    }

    return groupedReminders;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarColor: theme.primary,
    //     statusBarIconBrightness: Brightness.light));

    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: theme.surface,
            statusBarIconBrightness: theme.brightness));
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              CustomAppBar(
                title: 'Medication Reminder',
                subtitle: 'Reminder to take your pills on time',
                subtitleColor: theme.onPrimary.withOpacity(.7),
                textColor: theme.onPrimary,
                textSize: 18,
                bgColor: theme.primary,
                trailing: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            const MedicationReminderAddPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    side: BorderSide(
                        color: theme.onPrimary.withOpacity(.5), width: 2),
                  ),
                  icon: Icon(Icons.add, color: theme.onPrimary),
                ),
              ),
              const SizedBox(height: 16),
              // Weekly Date Picker
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: theme.primary.withOpacity(.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            DateTimeFormatUtil()
                                .getCurrentFormattedDateMY(selectedDate),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: theme.onSurface)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    WeeklyDatePicker(
                      enableWeeknumberText: false,
                      selectedDay: selectedDate,
                      changeDay: (DateTime newDate) {
                        setState(() {
                          selectedDate = newDate;
                        });
                      },
                      backgroundColor: theme.background,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'Reminders for ${DateFormat('MMM dd, yyyy').format(selectedDate)}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: theme.onSurface)),
                ],
              ),

              const SizedBox(height: 16),
              Expanded(
                child: _getRemindersForSelectedDate().isEmpty
                    ? const Center(
                    child: Text('No reminders found for selected date'))
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _groupRemindersByTime().length,
                  itemBuilder: (context, index) {
                    // Get the grouped reminders
                    final groupedReminders = _groupRemindersByTime();
                    final timeKey =
                    groupedReminders.keys.elementAt(index);
                    final reminderList = groupedReminders[timeKey]!;

                    return Container(
                      decoration: BoxDecoration(
                        color: theme.surface,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: theme.primary.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Display the common time for grouped reminders
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Time: $timeKey',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: theme.onSurface)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            // Display the names of the reminders in the same time group
                            ...reminderList.map((reminder) {
                              return Container(
                                margin: const EdgeInsets.only(top: 8),
                                child: Text(
                                  reminder.medicineName,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: theme.onSurface),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatTime(TimeOfDay time) {
    // Create a DateTime object using the time provided
    final DateTime dateTime = DateTime(0, 1, 1, time.hour, time.minute);

    // Format the time in 'hh:mm a' format
    return DateFormat('hh:mm a').format(dateTime);
  }
}