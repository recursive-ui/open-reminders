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

String capitalise(String s) => s[0].toUpperCase() + s.substring(1);

String? validatorForMissingFields(String? input) {
  if (input == null || input.isEmpty || input.trim().isEmpty) {
    return "Mandatory field";
  }
  return null;
}

String? validatorNumericField(String? input) {
  if (input != null && input != '') {
    if (double.tryParse(input) == null) {
      return "Needs to be a number";
    }
  }
  return null;
}

String? validatorRangeField(String? input) {
  if (input != null && input != '') {
    final validCharacters = RegExp(r'^[0-9]+-[0-9]+$');
    if (!validCharacters.hasMatch(input.replaceAll(' ', ''))) {
      return "Needs to be two numbers\n seperated by a dash\n e.g. 1-5";
    }
  }
  return null;
}

String? validatorListValuesField(String? input) {
  if (input != null && input != '') {
    final validCharacters = RegExp(r'^\d+(,\d+)*$');
    if (!validCharacters.hasMatch(input.replaceAll(' ', ''))) {
      return "Needs to be numbers\n seperated by commas\n e.g. 1,2,3";
    }
  }
  return null;
}
