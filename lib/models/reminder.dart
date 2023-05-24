import 'package:flutter/material.dart';
import 'package:open_reminders/utilities.dart';

enum TaskState { incomplete, completed }

class Task {
  late String name;
  String? description;
  DateTime? date;
  Duration? duration;
  List<Reminder>? reminders;
  Repeat? repeat;
  int? priority;
  List<String>? tags;
  String? category;
  TaskState taskState = TaskState.incomplete;
  DateTime? completedOn;

  Task(
    this.name, {
    this.description,
    this.date,
    this.duration,
    this.reminders,
    this.repeat,
    this.priority,
    this.tags,
    this.category,
  });

  Task.fromMap(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    date = DateTime.tryParse(json['date']);
    duration = Duration(minutes: json['duration']);
    reminders = json['reminders'];
    repeat = json['repeat'];
    priority = json['priority'];
    tags = json['tags'];
    category = json['category'];
    taskState = json['taskState'] == 'completed'
        ? TaskState.completed
        : TaskState.incomplete;
    completedOn = DateTime.tryParse(json['completedOn']);
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'description': description,
        'date': date == null ? null : date!.toIso8601String(),
        'duration': duration ?? duration?.inMinutes,
        'reminders': reminders == null
            ? null
            : reminders!.map((r) => r.toString()).toList(),
        'repeat': reminders == null ? null : repeat!.toMap,
        'priority': priority,
        'tags': tags,
        'category': category,
        'taskState':
            taskState == TaskState.completed ? 'completed' : 'incomplete',
        'completedOn':
            completedOn == null ? null : completedOn!.toIso8601String(),
      };
}

class Reminder {
  late Duration duration;
  TimeOfDay? time;
  Reminder({this.duration = const Duration(), this.time});

  DateTime getNextDate(DateTime dateTime) {
    DateTime nextDate = dateTime;
    nextDate = nextDate.subtract(duration);
    if (time != null) {
      nextDate = DateTime(
        nextDate.year,
        nextDate.month,
        nextDate.day,
        time!.hour,
        time!.minute,
      );
    }
    return nextDate;
  }

  String get prettyName {
    if (duration == const Duration() && time == null) {
      return 'On due date/time';
    }
    String durationString = '';

    if (duration == const Duration()) {
      durationString = 'that day';
    } else {
      if (duration.inDays > 0) {
        durationString += ' ${duration.inDays} days';
      }
      if (duration.inHours.remainder(24) > 0) {
        durationString += ' ${duration.inHours.remainder(24)} hours';
      }
      if (duration.inMinutes.remainder(60) > 0) {
        durationString += ' ${duration.inMinutes.remainder(60)} minutes';
      }
      return durationString.trim();
    }

    if (time == null) {
      return durationString;
    } else {
      return '${prettierTime(time)} $durationString';
    }
  }

  @override
  String toString() {
    return '$duration,$time';
  }

  Reminder.fromString(String string) {
    List<String> splitStrings = string.split(',');
    duration = parseTime(splitStrings[0]);
    time = tryParseTimeOfDay(splitStrings[1]);
  }
}

enum RepeatType { any, value, range, increment }

enum RepeatDuration { minutes, hours, days, weekdays, months }

class RepeatValue {
  RepeatType type;
  List<int>? value;

  RepeatValue(this.type, {this.value});

  int maxRange(RepeatDuration duration) {
    switch (duration) {
      case RepeatDuration.minutes:
        return 59;
      case RepeatDuration.hours:
        return 23;
      case RepeatDuration.days:
        return 364;
      case RepeatDuration.weekdays:
        return 6;
      case RepeatDuration.months:
        return 11;
      default:
        return 0;
    }
  }

  List<int>? toList(RepeatDuration duration) {
    switch (type) {
      case RepeatType.any:
        return List.generate(maxRange(duration) + 1, (i) => i);
      case RepeatType.range:
        return List.generate(value![1] - value![0] + 1, (i) => value![0] + i);
      case RepeatType.increment:
        return List.generate(
            (maxRange(duration) / value![0]).floor() + 1, (i) => value![0] * i);
      default:
        return value;
    }
  }

  RepeatValue.fromString(this.type, String? stringValue) {
    if (stringValue != null && stringValue != '') {
      switch (type) {
        case RepeatType.range:
          value = stringValue.split('-').map((e) => int.parse(e)).toList();
          break;
        case RepeatType.value:
          value = stringValue.split(',').map((e) => int.parse(e)).toList();
          break;
        default:
          value = [int.parse(stringValue)];
      }
    }
  }
}

class Repeat {
  List<int>? minutes;
  List<int>? hours;
  List<int>? days;
  List<int>? weekdays;
  List<int>? months;

  Repeat({
    RepeatValue? minutes,
    RepeatValue? hours,
    RepeatValue? days,
    RepeatValue? weekdays,
    RepeatValue? months,
  }) {
    if (minutes != null) {
      this.minutes = minutes.toList(RepeatDuration.minutes);
    }
    if (hours != null) {
      this.hours = hours.toList(RepeatDuration.hours);
    }
    if (days != null) {
      this.days = days.toList(RepeatDuration.days);
    }
    if (weekdays != null) {
      this.weekdays = weekdays.toList(RepeatDuration.weekdays);
    }
    if (months != null) {
      this.months = months.toList(RepeatDuration.months);
    }
  }

  DateTime getNextDate(DateTime? dateTime) {
    if (dateTime == null || dateTime.isBefore(DateTime.now())) {
      dateTime = DateTime.now();
      dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
          dateTime.hour, dateTime.minute);
    }
    dateTime = dateTime.add(const Duration(minutes: 1));

    while (true) {
      if (months?.contains(dateTime?.month) == false) {
        dateTime = DateTime(dateTime!.year, dateTime.month + 1, 1);
        continue;
      }
      if (weekdays?.contains(dateTime?.weekday) == false) {
        dateTime = dateTime?.add(const Duration(days: 1));
        continue;
      }
      if (days?.contains(dateTime?.day) == false) {
        dateTime = dateTime?.add(const Duration(days: 1));
        continue;
      }
      if (hours?.contains(dateTime?.hour) == false) {
        dateTime = dateTime?.add(const Duration(hours: 1));
        dateTime = dateTime?.subtract(Duration(minutes: dateTime.minute));
        continue;
      }
      if (minutes?.contains(dateTime?.minute) == false) {
        dateTime = dateTime?.add(const Duration(minutes: 1));
        continue;
      }
      return dateTime!;
    }
  }

  List<DateTime> getNextNDates(int n, {DateTime? dateTime}) {
    if (dateTime == null) {
      dateTime = DateTime.now();
      dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
          dateTime.hour, dateTime.minute);
      dateTime = dateTime.add(const Duration(minutes: 1));
    }
    List<DateTime> outDates = [];
    for (var i = 0; i < n; i++) {
      if (i == 0) {
        outDates.add(getNextDate(dateTime));
      } else {
        outDates.add(getNextDate(outDates[i - 1]));
      }
    }
    return outDates;
  }

  Map<String, List<int>> get toMap {
    Map<String, List<int>> outMap = {};
    if (minutes != null) {
      outMap['minutes'] = minutes!;
    }
    if (hours != null) {
      outMap['hours'] = hours!;
    }
    if (days != null) {
      outMap['days'] = days!;
    }
    if (weekdays != null) {
      outMap['weekdays'] = weekdays!;
    }
    if (months != null) {
      outMap['months'] = months!;
    }
    return outMap;
  }

  Repeat.fromMap(Map map) {
    if (map.containsKey('minutes')) {
      minutes = map[minutes];
    }
    if (map.containsKey('hours')) {
      hours = map[hours];
    }
    if (map.containsKey('days')) {
      days = map[days];
    }
    if (map.containsKey('weekdays')) {
      weekdays = map[weekdays];
    }
    if (map.containsKey('months')) {
      months = map[months];
    }
  }
}
