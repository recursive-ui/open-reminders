import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:open_reminders/extensions.dart';
import 'package:flutter/material.dart';
import 'package:open_reminders/models/reminder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskModel extends ChangeNotifier {
  List<Task> _tasks = [];
  String filePath = '';

  TaskModel() {
    _initModel();
  }

  List<Task> get tasks {
    return List.unmodifiable(_tasks);
  }

  List<Task> get incompleteTasks {
    return _tasks.where((e) => e.taskState == TaskState.incomplete).toList();
  }

  List<Task> get completeTasks {
    return _tasks.where((e) => e.taskState == TaskState.completed).toList();
  }

  int newRandomId() {
    if (_tasks.length > 9999) {
      return 0;
    }
    while (true) {
      int taskId = math.Random().nextInt(9999);
      Task? exists = _tasks.firstWhereOrNull((e) => e.id == taskId);
      if (exists == null) {
        return taskId;
      }
    }
  }

  int? getTaskIndexById(int taskId) {
    int index = _tasks.indexWhere((e) => e.id == taskId);
    if (index == -1) return null;
    return index;
  }

  Task? getTaskById(int taskId) {
    return _tasks.firstWhereOrNull((e) => e.id == taskId);
  }

  void addTask(Task newTask, {bool writeJson = true}) {
    if (newTask.id == -1) {
      int newId = newRandomId();
      newTask.id = newId;
    }

    _tasks.add(newTask);
    newTask.createNotification();
    notifyListeners();
    if (writeJson) writeData();
  }

  void completeTask(int taskId) {
    int? index = getTaskIndexById(taskId);
    if (index != null) {
      DateTime? nextRepeat = _tasks[index].getNextRepeat();

      Task nextTask = Task.from(_tasks[index]);
      _tasks[index].completedOn = DateTime.now();
      _tasks[index].taskState = TaskState.completed;
      _tasks[index].cancelNotification();

      if (nextRepeat != null) {
        nextTask.date = nextRepeat;
        nextTask.id = -1;
        addTask(nextTask, writeJson: false);
      }
    } else {
      deleteTask(taskId, writeJson: false);
    }
    writeData();
  }

  void deleteTask(int taskId,
      {bool writeJson = true, bool deleteCompleted = false}) {
    Task? taskData = getTaskById(taskId);
    if (taskData != null) {
      taskData.cancelNotification();
    }
    if (deleteCompleted) {
      _tasks.removeWhere(
          (e) => e.id == taskId && e.taskState == TaskState.completed);
    } else {
      _tasks.removeWhere(
          (e) => e.id == taskId && e.taskState == TaskState.incomplete);
    }

    notifyListeners();
    if (writeJson) writeData();
  }

  void snoozeTask(int taskId, {int inMinutes = 30}) {
    int? index = getTaskIndexById(taskId);
    if (index != null) {
      DateTime reminderTime = DateTime.now().add(Duration(minutes: inMinutes));
      _tasks[index].createNotification(notificationTime: reminderTime);
    }
  }

  Future<void> writeData() async {
    List<Map> testMap = _tasks.map((e) => e.toJson()).toList();
    final jsonData = jsonEncode(testMap);
    final file = File(filePath);
    await file.writeAsString(jsonData);
  }

  Future<void> _initModel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? folderPath = prefs.getString('data_directory');
    filePath = '$folderPath/reminders.json';
    if (!File(filePath).existsSync()) {
      File(filePath).createSync(recursive: true);
      _tasks = [];
    } else {
      String input = File(filePath).readAsStringSync();
      if (input == "") {
        _tasks = [];
      } else {
        List<dynamic> map = jsonDecode(input);
        _tasks = map.map((e) => Task.fromMap(e)).toList();
      }
    }
    notifyListeners();
  }
}
