import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateTime selectedDate = DateTime.now();
TimeOfDay selectedTime = TimeOfDay.now();
DateTime dateTime = DateTime.now();

// Select for Date
Future<DateTime> selectDate(BuildContext context) async {
  final selected = await showDatePicker(
    context: context,
    initialDate: selectedDate,
    firstDate: DateTime(2000),
    lastDate: DateTime(2025),
  );
  if (selected != null && selected != selectedDate) {
    selectedDate = selected;
  }
  return selectedDate;
}

// Select for Time
Future<TimeOfDay> selectTime(BuildContext context) async {
  final selected = await showTimePicker(
    context: context,
    initialTime: selectedTime,
  );
  if (selected != null && selected != selectedTime) {
    selectedTime = selected;
  }
  return selectedTime;
}
// select date time picker

Future<DateTime> selectDateTime(BuildContext context) async {
  await selectDate(context).then((sDate) async {
    await selectTime(context).then((sTime) {
      dateTime = DateTime(
        sDate.year,
        sDate.month,
        sDate.day,
        sTime.hour,
        sTime.minute,
      );
    });
  });
  return dateTime;
}

String getDate() {
  // ignore: unnecessary_null_comparison
  if (selectedDate == null) {
    return 'select date';
  } else {
    return DateFormat('MMM d, yyyy').format(selectedDate);
  }
}

// String getDateTime() {
//   // ignore: unnecessary_null_comparison
//   if (dateTime == null) {
//     return 'select date timer';
//   } else {
//     dateTime;
//   }
// }

String getTime(TimeOfDay tod) {
  final now = DateTime.now();

  final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
  final format = DateFormat.jm();
  return format.format(dt);
}
