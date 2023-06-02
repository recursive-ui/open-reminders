import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:open_reminders/constants.dart';
import 'package:open_reminders/extensions.dart';
import 'package:flutter/material.dart';
import 'package:open_reminders/models/calendar_data.dart';
import 'package:open_reminders/models/data_handler.dart';
import 'package:open_reminders/models/local_storage_handler.dart';
import 'package:open_reminders/models/reminder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskModel extends ChangeNotifier {
  late DataHandler dataHandler;
  List<Task> _tasks = [];
  String folderPath = '';
  bool isNotificationsAllowed = false;
  bool usePreciseNotifications = false;

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

  List<Meeting> meetings({DateTime? startDate, required DateTime endDate}) {
    startDate ??= DateTime.now();
    final List<Meeting> meetings = <Meeting>[];

    Duration duration = const Duration(minutes: 10);
    for (Task task in incompleteTasks) {
      if (task.date != null) {
        Color taskColour = ThemeColors.kCalendarAppointments[
            Random().nextInt(ThemeColors.kCalendarAppointments.length)];
        if (task.repeat == null) {
          meetings.add(
            Meeting(
              task.name,
              task.date!,
              task.date!.add(task.duration ?? duration),
              taskColour,
              false,
            ),
          );
        } else {
          List<DateTime> repeatDates = task.repeat!
              .getDatesBetween(startDate: startDate, endDate: endDate);
          for (DateTime repeat in repeatDates) {
            meetings.add(Meeting(
              task.name,
              repeat,
              repeat.add(task.duration ?? duration),
              taskColour,
              false,
            ));
          }
        }
      }
    }

    return meetings;
  }

  int newRandomId() {
    if (_tasks.length > 9999) {
      return 0;
    }
    while (true) {
      int taskId = Random().nextInt(9999);
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

  Future<void> addTask(Task newTask) async {
    if (newTask.id == -1) {
      int newId = newRandomId();
      newTask.id = newId;
    }

    checkNotificationsEnabled();
    _tasks.add(newTask);
    dataHandler.addTask(newTask);
    newTask.createNotification(preciseAlarm: usePreciseNotifications);

    notifyListeners();
  }

  Future<void> completeTask(int taskId) async {
    int? index = getTaskIndexById(taskId);
    if (index != null) {
      if (_tasks[index].taskState == TaskState.completed) {
        return;
      }
      DateTime? nextRepeat = _tasks[index].getNextRepeat();

      Task nextTask = Task.from(_tasks[index]);
      _tasks[index].completedOn = DateTime.now();
      _tasks[index].taskState = TaskState.completed;
      _tasks[index].cancelNotification();
      dataHandler.updateTask(_tasks[index]);

      if (nextRepeat != null) {
        nextTask.date = nextRepeat;
        nextTask.id = -1;
        addTask(nextTask);
      } else {
        notifyListeners();
      }
    } else {
      deleteTask(taskId);
    }
  }

  Future<void> skipTask(int taskId) async {
    int? index = getTaskIndexById(taskId);
    if (index != null) {
      if (_tasks[index].taskState == TaskState.completed) {
        return;
      }
      DateTime? nextRepeat = _tasks[index].getNextRepeat();

      if (nextRepeat != null) {
        Task nextTask = Task.from(_tasks[index]);
        nextTask.date = nextRepeat;
        nextTask.id = -1;
        addTask(nextTask);
      }
    }
    deleteTask(taskId);
  }

  void deleteTask(int taskId, {bool deleteCompleted = false}) async {
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
    dataHandler.deleteTask(taskId);
    notifyListeners();
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

  void checkScheduledNotifications() async {
    List<NotificationModel> notifications =
        await AwesomeNotifications().listScheduledNotifications();
    List<int> currentTaskIds = [];
    for (Task task in incompleteTasks) {
      if (task.hasValidReminder) {
        currentTaskIds.add(task.id);
      }
    }
    List<int> currentNotificationIds = [];
    for (NotificationModel notification in notifications) {
      if (notification.content != null) {
        if (notification.content!.payload != null) {
          int? notificationId =
              int.tryParse(notification.content!.payload!['id']!);
          if (notificationId != null) {
            if (!currentTaskIds.contains(notificationId)) {
              AwesomeNotifications().cancel(notificationId);
            } else {
              currentNotificationIds.add(notificationId);
            }
          }
        }
      }
    }
    List<int> missingNotifications = Set<int>.from(currentTaskIds)
        .difference(Set<int>.from(currentNotificationIds))
        .toList();
    for (int taskId in missingNotifications) {
      Task? task = getTaskById(taskId);
      if (task != null) {
        task.createNotification();
      }
    }
  }

  Future<bool> getPreciseNotifications() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? usePrecise = prefs.getBool('use_precise_notifications');
    if (usePrecise != null) {
      return usePrecise;
    }
    return false;
  }

  Future<void> setPreciseNotifications(bool newUsePrecise) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    usePreciseNotifications = newUsePrecise;
    await prefs.setBool('use_precise_notifications', newUsePrecise);
  }

  Future<void> _initModel() async {
    dataHandler = LocalStorageHandler();
    await dataHandler.initialise();
    _tasks = await dataHandler.readTasks();
    isNotificationsAllowed =
        await AwesomeNotifications().isNotificationAllowed();
    usePreciseNotifications = await getPreciseNotifications();
    checkScheduledNotifications();
    notifyListeners();
  }
}
