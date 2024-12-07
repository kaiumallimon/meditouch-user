import 'package:intl/intl.dart';

class DateTimeFormatUtil{
  String getCurrentFormattedDateDashboard(){
    // Friday, 4 Sept
    return DateFormat('EEEE, d MMM').format(DateTime.now());
  }

  String dobFormatter(String dob){
    // May 4, 2021
    return DateFormat('MMM d, yyyy').format(DateTime.parse(dob));
  }
}