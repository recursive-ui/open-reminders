import 'package:open_reminders/models/reminder.dart';

abstract class DataHandler {
  Future<void> addTask(Task newTask);
  Future<void> deleteTask(int taskId);
  Future<List<Task>> readTasks();
  Future<void> initialise();
}
