import 'package:intl/intl.dart';

class DateTimeFormatUtil{
  String getCurrentFormattedDateMY(DateTime now) {
    DateFormat formatter = DateFormat('MMM yyyy');
    return formatter.format(now);
  }
}