class Task {
  late String name;
  String? description;
  DateTime? date;
  List<DateTime>? times;
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
    times = json['times'];
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
        'times': times == null
            ? []
            : times!.map((t) => t.toIso8601String()).toList(),
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
