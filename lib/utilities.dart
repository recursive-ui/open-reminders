import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String? prettyDate(DateTime? dateTime) {
  if (dateTime == null) {
    return null;
  }
  DateTime now = DateTime.now();
  if (dateOnly(dateTime) == dateOnly(now)) {
    return 'Today';
  }
  int daysDiff = dateOnly(dateTime).difference(dateOnly(now)).inDays;
  if (daysDiff >= 0 && daysDiff < 8) {
    return DateFormat('E').format(dateTime);
  }
  return DateFormat('MMM d').format(dateTime);
}

DateTime dateOnly(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day);
}

String? prettyTime(TimeOfDay? timeOfDay) {
  if (timeOfDay == null) {
    return null;
  }
  return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
}

String? prettyDuration(Duration? duration) {
  if (duration == null) {
    return null;
  }
  List<String> outDuration = [];
  if (duration.inDays > 0) {
    outDuration.add("${duration.inDays}d");
  }
  if (duration.inHours > 0) {
    outDuration.add("${duration.inHours}hr");
  }
  if (duration.inMinutes.remainder(60) > 0) {
    outDuration.add("${duration.inMinutes.remainder(60)}min");
  }
  return outDuration.join(" ");
}
