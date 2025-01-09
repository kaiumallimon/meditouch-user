// Date and time widget
  import 'package:flutter/material.dart';

import '../../../../../../../common/utils/datetime_format.dart';

Text buildDateAndTime(ColorScheme theme) {
    return Text(
      DateTimeFormatUtil().getCurrentFormattedDateDashboard(),
      style: TextStyle(
          fontSize: 14, color: theme.onSurface.withOpacity(.7), height: 1
          // fontWeight: FontWeight.w600,
          ),
    );
  }