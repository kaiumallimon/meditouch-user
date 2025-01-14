import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meditouch/features/dashboard/features/doctors/data/models/doctor_model.dart';

class DetailedDoctorRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// fetch appointment timeslots
  ///
  ///

  Future<Map<String, List<Map<String, dynamic>>>> fetchAppointmentSlots(
      String doctorId) async {
    try {
      // Fetch the doctor's schedule document from Firestore
      final doctorSchedule = await _firestore
          .collection('db_client_doctor_accountinfo')
          .doc(doctorId)
          .get();

      // Check if the document exists and contains data
      if (doctorSchedule.exists && doctorSchedule.data() != null) {
        final data = doctorSchedule.data()!;

        // Check if the 'timeslots' field exists and is a valid map
        if (data.containsKey('timeSlots') &&
            data['timeSlots'] is Map<String, dynamic>) {
          final timeslots = data['timeSlots'] as Map<String, dynamic>;

          // Prepare the result map
          final result = <String, List<Map<String, dynamic>>>{};

          // Process each date and its associated time slots
          timeslots.forEach((date, periods) {
            // Ensure the periods are a list of maps
            if (periods is List<dynamic>) {
              result[date] = periods
                  .where((item) =>
                      item is Map<String, dynamic>) // Ensure items are maps
                  .map((item) => item as Map<String, dynamic>)
                  .toList();
            }
          });

          // filter out the past timeslots
          final now = DateTime.now();

          int count = 0;

          result.removeWhere((key, value) {
            // Parse the key (date string) into a DateTime object
            final date = DateTime.parse(key);

            // Condition to remove dates in the past
            bool isPastDate = date.isBefore(DateTime.now());

            // Optionally, you can add other conditions
            // For example, remove if the timeslots list is empty:
            bool isEmptyTimeSlots = (value.isEmpty);

            // Remove the date if it meets the conditions
            if (isPastDate || isEmptyTimeSlots) {
              count++;
              return true;
            }

            return false;
          });

          print('Removed $count past or empty dates');

          final sortedKeys = result.keys.toList()..sort();
          final sortedResult = {
            for (var key in sortedKeys) key: result[key]!,
          };

          return sortedResult;
        }
      }

      print('Doctor schedule not found or invalid');

      // Return an empty map if timeslots are missing or invalid
      return {};
    } catch (e) {
      print('Error fetching appointment slots: $e');
      return {};
    }
  }

  Stream<Map<String, dynamic>> getDoctorDetails(String doctorId) {
    return _firestore
        .collection('db_client_doctor_accountinfo')
        .doc(doctorId)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data();

      if (data != null) {
        return {
          'status': true,
          'doctor': DoctorModel.fromJson(data, doctorId),
          'message': 'Doctor details found'
        };
      }

      return {'status': false, 'message': 'Doctor details not found'};
    });
  }
}
