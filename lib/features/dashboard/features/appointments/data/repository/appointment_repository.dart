import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
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

          // Separate appointments based on the 'isCompleted' field
          if (data['isCompleted'] == true) {
            pastAppointments.add(appointment);
          } else {
            upcomingAppointments.add(appointment);
          }
        }

        log('Appointments fetched successfully');
        log('Upcoming: ${upcomingAppointments.first.toJson()}');
        log('Past: $pastAppointments');
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
}
