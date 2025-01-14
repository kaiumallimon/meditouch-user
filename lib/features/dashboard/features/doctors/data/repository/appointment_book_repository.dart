import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/appointment_model.dart';

class AppointmentBookRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Book an appointment
  ///
  ///

  Future<bool> bookAppointment({
    required AppointmentModel appointmentModel,
  }) async {
    try {
      final appointmentRef =
          _firestore.collection('db_client_multi_appointments').doc();
      await appointmentRef.set(appointmentModel.toJson());

      /// create a notification for the doctor
      ///

      final notificationRef =
          _firestore.collection('db_client_multi_notification').doc();

      // mark the time slot as booked
      final doctorScheduleRef = _firestore
          .collection('db_client_doctor_accountinfo')
          .doc(appointmentModel.doctorId);

      final doctorSchedule = await doctorScheduleRef.get();

      if (doctorSchedule.exists && doctorSchedule.data() != null) {
        final data = doctorSchedule.data()!;

        if (data.containsKey('timeSlots') &&
            data['timeSlots'] is Map<String, dynamic>) {
          final timeslots = data['timeSlots'] as Map<String, dynamic>;

          // Find the date and time slot to mark as booked
          final date = appointmentModel.appointmentDate;
          final timeSlot = appointmentModel.appointmentTimeSlot;

          // Check if the date exists in the schedule
          if (timeslots.containsKey(date)) {
            final periods = timeslots[date] as List<dynamic>;

            // Find the time slot to mark as booked
            final index = periods.indexWhere((item) =>
                item is Map<String, dynamic> &&
                item['time'] == timeSlot &&
                item['isBooked'] == false);

            if (index != -1) {
              periods[index]['isBooked'] = true;
              periods[index]['bookedBy'] = appointmentModel.patientId;

              // Update the doctor's schedule
              await doctorScheduleRef.update({
                'timeSlots': timeslots,
              });
            }
          }
        }
      }

      /// set the notification data
      await notificationRef.set({
        'title': 'New Appointment',
        'message': 'You have a new appointment request',
        'userId': appointmentModel.doctorId,
        'type': 'appointment',
        'status': 'unread',
        'timestamp': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print('Error booking appointment: $e');
      return false;
    }
  }
}
