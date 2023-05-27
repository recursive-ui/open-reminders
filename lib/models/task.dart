import 'dart:math' as math;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:open_reminders/extensions.dart';
import 'package:flutter/material.dart';
import 'package:open_reminders/models/json_handler.dart';
import 'package:open_reminders/models/reminder.dart';

class TaskModel extends ChangeNotifier {
  List<Task> _tasks = [];
  String folderPath = '';
  bool isNotificationsAllowed = false;

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

    checkNotificationsEnabled();
    _tasks.add(newTask);
    newTask.createNotification();
    notifyListeners();
    if (writeJson) JSONHandler.writeData(_tasks, folderPath);
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
    JSONHandler.writeData(_tasks, folderPath);
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
    if (writeJson) JSONHandler.writeData(_tasks, folderPath);
  }

  void snoozeTask(int taskId, {int inMinutes = 30}) {
    int? index = getTaskIndexById(taskId);
    if (index != null) {
      DateTime reminderTime = DateTime.now().add(Duration(minutes: inMinutes));
      _tasks[index].createNotification(notificationTime: reminderTime);
    }
  }

  void checkNotificationsEnabled() async {
    if (!isNotificationsAllowed) {
      isNotificationsAllowed =
          await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  Future<void> _initModel() async {
    folderPath = await JSONHandler.getDefaultStorageDirectory();
    _tasks = await JSONHandler.readData(folderPath);
    isNotificationsAllowed =
        await AwesomeNotifications().isNotificationAllowed();
    notifyListeners();
  }
}
