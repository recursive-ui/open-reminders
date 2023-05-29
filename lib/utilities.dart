import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_reminders/models/reminder.dart';

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

String? prettyCompletedDate(DateTime? dateTime) {
  if (dateTime == null) {
    return null;
  }

  String? time = prettierTime(TimeOfDay.fromDateTime(dateTime));
  DateTime now = DateTime.now();

  if (dateOnly(dateTime) == dateOnly(now)) {
    return 'Today $time';
  }

  int daysDiff = dateOnly(dateTime).difference(dateOnly(now)).inDays;
  if (daysDiff >= 0 && daysDiff < 8) {
    return '${DateFormat('E').format(dateTime)} $time';
  }
  return '${DateFormat('MMM d').format(dateTime)} $time';
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

String? prettierTime(TimeOfDay? timeOfDay) {
  if (timeOfDay == null) {
    return null;
  }
  String minute = timeOfDay.minute.toString().padLeft(2, '0');
  String amPm = timeOfDay.period.name;

  return '${timeOfDay.hourOfPeriod}:$minute $amPm';
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
    List<int> range = input.split('-').map((e) => int.parse(e)).toList();
    if (range[0] > range[1]) {
      return 'Second number needs to be greater than the first.';
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

Duration parseTime(String input) {
  final parts = input.split(':');

  if (parts.length != 3) throw const FormatException('Invalid time format');

  int days;
  int hours;
  int minutes;
  int seconds;
  int milliseconds;
  int microseconds;

  {
    final p = parts[2].split('.');

    if (p.length != 2) throw const FormatException('Invalid time format');

    final p2 = int.parse(p[1].padRight(6, '0'));
    microseconds = p2 % 1000;
    milliseconds = p2 ~/ 1000;

    seconds = int.parse(p[0]);
  }

  minutes = int.parse(parts[1]);

  {
    int p = int.parse(parts[0]);
    hours = p % 24;
    days = p ~/ 24;
  }

  return Duration(
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
      microseconds: microseconds);
}

Duration? tryParseTime(String input) {
  try {
    return parseTime(input);
  } catch (_) {
    return null;
  }
}

TimeOfDay parseTimeOfDay(String input) {
  final parts = input.split(':');

  if (parts.length != 2) throw const FormatException('Invalid time format');

  int hours;
  int minutes;

  minutes = int.parse(parts[1]);

  {
    int p = int.parse(parts[0]);
    hours = p % 24;
  }

  return TimeOfDay(hour: hours, minute: minutes);
}

TimeOfDay? tryParseTimeOfDay(String input) {
  try {
    return parseTimeOfDay(input);
  } catch (_) {
    return null;
  }
}

bool areListsEqual(var list1, var list2) {
  if (!(list1 is List && list2 is List) || list1.length != list2.length) {
    return false;
  }

  for (int i = 0; i < list1.length; i++) {
    if (list1[i] != list2[i]) {
      return false;
    }
  }

  return true;
}

bool areRemindersEqual(List<Reminder>? one, List<Reminder>? two) {
  if (one == null && two == null) {
    return true;
  }
  if (one == null || two == null) {
    return false;
  }

  int i = -1;
  return one.every((element) {
    i++;
    return two[i].isEqual(element);
  });
}

bool areRepeatsEqual(Repeat? one, Repeat? two) {
  if (one == null && two == null) {
    return true;
  }
  if (one == null || two == null) {
    return false;
  }

  return one.isEqual(two);
}
