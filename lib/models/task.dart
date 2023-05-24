import 'dart:convert';
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:open_reminders/models/reminder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskModel extends ChangeNotifier {
  Map<String, Task> _tasks = {};
  String filePath = '';

  TaskModel() {
    _initModel();
  }

  Map<String, Task> get tasks {
    return Map.unmodifiable(_tasks);
  }

  Map<String, Task> get incompleteTasks {
    Map<String, Task> tmpTasks = {};
    _tasks.forEach((key, value) {
      if (value.taskState == TaskState.incomplete) {
        tmpTasks[key] = value;
      }
    });
    return tmpTasks;
  }

  Map<String, Task> get completeTasks {
    Map<String, Task> tmpTasks = {};
    _tasks.forEach((key, value) {
      if (value.taskState == TaskState.completed) {
        tmpTasks[key] = value;
      }
    });
    return tmpTasks;
  }

  void addTask(Task newTask) {
    String taskKey = UniqueKey().toString();
    _tasks[taskKey] = newTask;
    if (newTask.reminders != null && newTask.date != null) {
      if (newTask.reminders!.isNotEmpty) {
        for (Reminder reminder in newTask.reminders!) {
          AwesomeNotifications().createNotification(
            schedule: NotificationCalendar.fromDate(
                date: reminder.getNextDate(newTask.date!)),
            content: NotificationContent(
                id: 10,
                channelKey: 'open_reminders',
                title: newTask.name,
                body: newTask.description,
                actionType: ActionType.Default),
            actionButtons: [
              NotificationActionButton(key: 'complete', label: 'Complete'),
              NotificationActionButton(key: 'snooze', label: 'Snooze'),
            ],
          );
        }
      }
    }
    notifyListeners();
  }

  Future<void> writeData() async {
    final jsonData = jsonEncode(
        _tasks.map<String, Map>((key, value) => MapEntry(key, value.toMap())));
    final file = File(filePath);
    await file.writeAsString(jsonData);
  }

  Future<void> _initModel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? folderPath = prefs.getString('data_directory');
    filePath = '$folderPath/reminders.json';
    if (!File(filePath).existsSync()) {
      File(filePath).createSync(recursive: true);
      _tasks = {};
    } else {
      String input = File(filePath).readAsStringSync();
      if (input == "") {
        _tasks = {};
      } else {
        Map map = jsonDecode(input);
        _tasks = map.map((key, value) => MapEntry(key, Task.fromMap(value)));
      }
    }
    notifyListeners();
  }
}
