import 'package:intl/intl.dart';

class DateTimeFormatUtil {
  String getCurrentFormattedDateDashboard() {
    // Friday, 4 Sept
    return DateFormat('EEEE, d MMM').format(DateTime.now());
  }

  String dobFormatter(String dob) {
    // May 4, 2021
    return DateFormat('MMM d, yyyy').format(DateTime.parse(dob));
  }

  String getFormattedAddedDateTime(String time) {
    // May 4, 2021 AT 12:00 PM

    return DateFormat('MMM d, yyyy').add_jm().format(DateTime.parse(time));
  }


  String formatAppointmentTime(String date, String timeslot){
    // timeslot: 09:00 AM - 10:00 AM
    // date: 2021-09-04
    // 4 Sept, 09:00 AM - 10:00 AM

    final formattedDate = DateFormat('d MMM').format(DateTime.parse(date));

    return '$formattedDate, $timeslot';
    
  }
}
