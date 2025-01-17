import 'package:flutter/material.dart';

class MedicineReminder {
  int? id; // Optional ID for SQLite
  String medicineName;
  TimeOfDay reminderTime;
  DateTime fromDate;
  DateTime toDate;

  MedicineReminder({
    this.id, // Allow id to be optional
    required this.medicineName,
    required this.reminderTime,
    required this.fromDate,
    required this.toDate,
  });

  // Convert a reminder into a map for SQLite storage
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Include id in the map
      'medicineName': medicineName,
      'reminderTime': '${reminderTime.hour}:${reminderTime.minute}', // Store TimeOfDay as a string
      'fromDate': fromDate.toIso8601String(),
      'toDate': toDate.toIso8601String(),
    };
  }

  // Convert a map from SQLite back into a reminder
  static MedicineReminder fromMap(Map<String, dynamic> map) {
    List<String> timeParts = map['reminderTime'].split(':');
    TimeOfDay reminderTime = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );

    return MedicineReminder(
      id: map['id'], // Retrieve id from the map
      medicineName: map['medicineName'],
      reminderTime: reminderTime,
      fromDate: DateTime.parse(map['fromDate']),
      toDate: DateTime.parse(map['toDate']),
    );
  }
}