import 'package:flutter/material.dart';

class Task {
  late String name;
  String? description;
  DateTime? date;
  List<TimeOfDay>? time;
  Duration? duration;
  List<Reminder>? reminders;
  List<Repeat>? repeat;
  int? priority;
  List<String>? tags;
  String? category;

  Task.fromMap(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    date = json['date'];
    time = json['times'];
    duration = json['duration'];
    reminders = json['reminders'];
    repeat = json['repeat'];
    priority = json['priority'];
    tags = json['tags'];
    category = json['category'];
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'description': description,
        'date': date == null ? null : date!.toIso8601String(),
        'time': time == null ? [] : time!.map((t) => t.toString()).toList(),
        'duration': duration ?? duration.toString(),
        'reminders': reminders == null
            ? null
            : reminders!.map((r) => r.toString()).toList(),
        'repeat': reminders == null
            ? null
            : repeat!.map((r) => r.toString()).toList(),
        'priority': priority,
        'tags': tags,
        'category': category,
      };
}

class Reminder {}

class Repeat {}
