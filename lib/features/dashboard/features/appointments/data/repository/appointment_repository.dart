import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../../doctors/data/models/appointment_model.dart';

class AppointmentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch both 'upcoming' and 'past' appointments for a patient
  Stream<Map<String, dynamic>> getAppointments(String patientId) async* {
    try {
      final snapshots = _firestore
          .collection('db_client_multi_appointments')
          .where('patientId', isEqualTo: patientId)
          .snapshots();

      await for (final snapshot in snapshots) {
        final upcomingAppointments = <AppointmentModel>[];
        final pastAppointments = <AppointmentModel>[];

        for (final doc in snapshot.docs) {
          final data = doc.data();
          final appointment = AppointmentModel.fromJson(data, doc.id);

          // build the appointment date by parsing
          // date:
          final date = appointment.appointmentDate;
          final time = appointment.appointmentTimeSlot.split('-')[0].trim();
          final dateTime = '$date $time';

          final appointmentDateTime = parseDateTime(dateTime);

          // check if the date is in the past
          bool isPast = appointmentDateTime.isBefore(DateTime.now());

          // Separate appointments based on the 'isCompleted' field
          if (data['isCompleted'] == true || isPast) {
            pastAppointments.add(appointment);
          } else {
            upcomingAppointments.add(appointment);
          }
        }

        log('Appointments fetched successfully');
        if (upcomingAppointments.isNotEmpty) {
          log('Upcoming: ${upcomingAppointments.first.toJson()}');
        } else {
          log('No upcoming appointments.');
        }

        yield {
          'status': true,
          'message': 'Appointments fetched successfully',
          'data': {
            'upcoming': upcomingAppointments,
            'past': pastAppointments,
          },
        };
      }
    } catch (e) {
      log('Failed to fetch appointments: $e');
      yield {
        'status': false,
        'message': 'Failed to fetch appointments: $e',
      };
    }
  }

  Stream<bool> isCallFinished(String appointmentId) async* {
    try {
      final snapshots = _firestore
          .collection('db_client_multi_appointments')
          .doc(appointmentId)
          .snapshots();

      await for (final snapshot in snapshots) {
        final data = snapshot.data();
        yield data!['isCompleted'];
      }
    } catch (e) {
      log('Failed to check call status: $e');
      yield false;
    }
  }
}

/// Parses a datetime string into a DateTime object.
///
/// The [dateTimeString] must follow the format "yyyy-MM-dd h:mm a".
/// Returns the corresponding DateTime object.
DateTime parseDateTime(String dateTimeString) {
  final format = DateFormat("yyyy-MM-dd h:mm a");
  return format.parse(dateTimeString);
}
