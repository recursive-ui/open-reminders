import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:open_reminders/constants.dart';
import 'package:open_reminders/utilities.dart';

enum TaskState { incomplete, completed }

class Task {
  late String name;
  late int id;
  String? description;
  DateTime? date;
  Duration? duration;
  List<Reminder>? reminders;
  Repeat? repeat;
  int? priority;
  List<String>? tags;
  String? category;
  late TaskState taskState;
  DateTime? completedOn;

  Task(
    this.name, {
    this.id = -1,
    this.description,
    this.date,
    this.duration,
    this.reminders,
    this.repeat,
    this.priority,
    this.tags,
    this.category,
    this.taskState = TaskState.incomplete,
    this.completedOn,
  });

  void createNotification(
      {DateTime? notificationTime, bool preciseAlarm = false}) {
    if (reminders != null && date != null) {
      if (reminders!.isNotEmpty) {
        DateTime? nextReminder = notificationTime;
        nextReminder ??= getNextReminder();

        if (nextReminder != null) {
          AwesomeNotifications().createNotification(
            schedule: NotificationCalendar.fromDate(
              date: nextReminder,
              preciseAlarm: preciseAlarm,
            ),
            content: NotificationContent(
                id: id,
                channelKey: 'open_reminders',
                groupKey: 'open_reminders_group',
                backgroundColor: ThemeColors.kPrimary,
                color: ThemeColors.kOnPrimary,
                title: name,
                body: description,
                icon: 'resource://drawable/notification_icon',
                // largeIcon: 'resource://drawable/notification_icon_full',
                payload: {'id': id.toString()},
                actionType: ActionType.Default),
            actionButtons: [
              NotificationActionButton(key: 'complete', label: 'Complete'),
              NotificationActionButton(
                  key: 'snooze', label: 'Snooze', color: ThemeColors.kError),
            ],
          );
        }
      }
    }
  }

  bool get isOverdue {
    if (date != null) {
      if (DateTime.now().isAfter(date!)) {
        return true;
      }
    }
    return false;
  }

  DateTime? getNextRepeat() {
    if (repeat == null) {
      return null;
    }
    if (date != null) {
      if (date!.isAfter(DateTime.now())) {
        return repeat!.getNextDate(dateTime: date);
      }
    }
    return repeat!.getNextDate();
  }

  DateTime? getNextReminder() {
    if (!hasReminder || date == null) {
      return null;
    }

    DateTime reminderDate = date!;
    if (DateTime.now().isAfter(reminderDate)) {
      DateTime? newDate = getNextRepeat();
      if (newDate != null) {
        reminderDate = newDate;
      }
    }

    List<DateTime> nextDates =
        reminders!.map((e) => e.getNextDate(reminderDate)).toList();
    return nextDates.reduce((min, e) => e.isBefore(min) ? e : min);
  }

  void cancelNotification() {
    AwesomeNotifications().cancel(id);
  }

  bool get hasReminder {
    if (reminders != null) {
      if (reminders!.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  bool get hasValidReminder {
    if (hasReminder) {
      DateTime? nextReminder = getNextReminder();
      if (nextReminder != null) {}
      if (DateTime.now().isBefore(nextReminder!)) {
        return true;
      }
    }
    return false;
  }

  bool isEqual(
    Task other, {
    bool ignoreId = true,
    bool ignoreDate = false,
    bool ignoreCompleted = false,
  }) {
    bool idsEqual = true;
    if (!ignoreId) {
      idsEqual = id == other.id;
    }
    bool datesEqual = true;
    if (!ignoreDate) {
      datesEqual = date == other.date;
    }
    bool completedEqual = true;
    if (!ignoreCompleted) {
      completedEqual =
          completedOn == other.completedOn && taskState == other.taskState;
    }
    if (idsEqual &&
        name == other.name &&
        description == other.description &&
        datesEqual &&
        duration == other.duration &&
        areRemindersEqual(reminders, other.reminders) &&
        areRepeatsEqual(repeat, other.repeat) &&
        priority == other.priority &&
        tags == other.tags &&
        category == other.category &&
        completedEqual) {
      return true;
    }
    return false;
  }

  Task.fromMap(Map json) {
    id = json['id'] ?? -1;
    name = json['name'];
    description = json['description'];
    date = json['date'] == null ? null : DateTime.tryParse(json['date']);
    duration =
        json['duration'] == null ? null : Duration(minutes: json['duration']);
    reminders = json['reminders'] == null
        ? null
        : List.from(json['reminders'].map((e) => Reminder.fromString(e)));
    repeat = json['repeat'] == null ? null : Repeat.fromMap(json['repeat']);
    priority = json['priority'] == null ? null : int.tryParse(json['priority']);
    tags = json['tags'];
    category = json['category'];
    taskState = json['taskState'] == 'completed'
        ? TaskState.completed
        : TaskState.incomplete;
    completedOn = json['completedOn'] == null
        ? null
        : DateTime.tryParse(json['completedOn']);
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'date': date == null ? null : date!.toIso8601String(),
        'duration': duration?.inMinutes,
        'reminders': reminders == null
            ? null
            : reminders!.map((r) => r.toString()).toList(),
        'repeat': repeat == null ? null : repeat!.toMap,
        'priority': priority,
        'tags': tags,
        'category': category,
        'taskState':
            taskState == TaskState.completed ? 'completed' : 'incomplete',
        'completedOn':
            completedOn == null ? null : completedOn!.toIso8601String(),
      };

  factory Task.from(Task task) {
    return Task(
      task.name,
      id: task.id,
      description: task.description,
      date: task.date,
      duration: task.duration,
      reminders: task.reminders,
      repeat: task.repeat,
      priority: task.priority,
      tags: task.tags,
      category: task.category,
      taskState: task.taskState,
      completedOn: task.completedOn,
    );
  }
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

  bool isEqual(Reminder other) {
    if (duration == other.duration && time == other.time) return true;
    return false;
  }
}

enum RepeatType { any, value, range, increment }

enum RepeatDuration { minutes, hours, days, weekdays, months }

extension RepeatDurationExtensions on RepeatDuration {
  String get pluralName {
    return ['minutes', 'hours', 'days', 'weekdays', 'months'][index];
  }

  String get longName {
    return ['minute', 'hour', 'day', 'day', 'month'][index];
  }

  String get shortName {
    return ['min', 'hr', 'day', 'wkday', 'mon'][index];
  }
}

class RepeatValue {
  late RepeatType type;
  List<int>? value;

  RepeatValue(this.type, {this.value}) {
    if (value == []) {
      value == null;
    }
  }

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

  RepeatValue.fromList(this.value, {RepeatDuration? duration}) {
    type = RepeatType.value;
    if (value != null) {
      if (duration != null) {
        List<int> everyTest = List.generate(maxRange(duration) + 1, (i) => i);
        if (areListsEqual(value, everyTest)) {
          type = RepeatType.any;
          value = null;
        }
      }
    }
  }

  String weekdayName(int index) {
    return ['Sun', 'Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat'][index];
  }

  String get prettyWeekdayName {
    if (value == null) {
      return '';
    }
    switch (type) {
      case RepeatType.any:
        return 'Sun-Sat';
      case RepeatType.range:
        return '${weekdayName(value![1])}-${weekdayName(value![0])}';
      case RepeatType.increment:
        return 'every ${weekdayName(value![0])}';
      default:
        return value!.map((e) => weekdayName(e)).toList().join(',');
    }
  }

  String prettyString(RepeatDuration duration) {
    String dur = duration.pluralName;

    if (duration == RepeatDuration.weekdays) {
      return prettyWeekdayName;
    }

    switch (type) {
      case RepeatType.any:
        return 'every ${duration.longName}';
      case RepeatType.range:
        return 'between ${value![0]} and ${value![1]} $dur';
      case RepeatType.increment:
        return 'every ${value![0]} $dur';
      default:
        return 'at ${value!.join(',')} $dur';
    }
  }
}

class Repeat {
  List<int>? minutes;
  List<int>? hours;
  List<int>? days;
  List<int>? weekdays;
  List<int>? months;
  String? name;

  Repeat({
    RepeatValue? minutes,
    RepeatValue? hours,
    RepeatValue? days,
    RepeatValue? weekdays,
    RepeatValue? months,
  }) {
    List<String> outName = [];

    if (minutes != null) {
      this.minutes = minutes.toList(RepeatDuration.minutes);
      outName.add(minutes.prettyString(RepeatDuration.minutes));
    }

    if (hours != null) {
      this.hours = hours.toList(RepeatDuration.hours);
      outName.add(hours.prettyString(RepeatDuration.hours));
    }

    if (days != null) {
      this.days = days.toList(RepeatDuration.days);
      outName.add(days.prettyString(RepeatDuration.days));
    }

    if (weekdays != null) {
      this.weekdays = weekdays.toList(RepeatDuration.weekdays);
      outName.add(weekdays.prettyString(RepeatDuration.weekdays));
    }

    if (months != null) {
      this.months = months.toList(RepeatDuration.months);
      outName.add(months.prettyString(RepeatDuration.months));
    }

    name = outName.join(' ');
  }

  DateTime getNextDate({DateTime? dateTime}) {
    if (dateTime == null || dateTime.isBefore(DateTime.now())) {
      dateTime = DateTime.now();
      dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
          dateTime.hour, dateTime.minute);
    }
    dateTime = dateTime.add(const Duration(minutes: 1));

    removeEmptyLists();

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

  void removeEmptyLists() {
    if (months != null) {
      if (months!.isEmpty) {
        months = null;
      }
    }
    if (weekdays != null) {
      if (weekdays!.isEmpty) {
        weekdays = null;
      }
    }
    if (days != null) {
      if (days!.isEmpty) {
        days = null;
      }
    }
    if (hours != null) {
      if (hours!.isEmpty) {
        hours = null;
      }
    }
    if (minutes != null) {
      if (minutes!.isEmpty) {
        minutes = null;
      }
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
        outDates.add(getNextDate(dateTime: dateTime));
      } else {
        outDates.add(getNextDate(dateTime: outDates[i - 1]));
      }
    }
    return outDates;
  }

  Map<String, dynamic> get toMap {
    return {
      'minutes': minutes,
      'hours': hours,
      'days': days,
      'weekdays': weekdays,
      'months': months,
      'name': name,
    };
  }

  Repeat.fromMap(Map map) {
    minutes = map['minutes']?.cast<int>();
    hours = map['hours']?.cast<int>();
    days = map['days']?.cast<int>();
    weekdays = map['weekdays']?.cast<int>();
    months = map['months']?.cast<int>();
    name = map['name'];
  }

  bool isEqual(Repeat other) {
    if (minutes == other.minutes &&
        hours == other.hours &&
        days == other.days &&
        weekdays == other.weekdays &&
        months == other.months) {
      return true;
    }

    return false;
  }

  Map<String, RepeatValue> get toRepeatValueMap {
    return {
      'minutes':
          RepeatValue.fromList(minutes, duration: RepeatDuration.minutes),
      'hours': RepeatValue.fromList(hours, duration: RepeatDuration.hours),
      'days': RepeatValue.fromList(days, duration: RepeatDuration.days),
      'weekdays':
          RepeatValue.fromList(weekdays, duration: RepeatDuration.weekdays),
      'months': RepeatValue.fromList(months, duration: RepeatDuration.months),
    };
  }
}
