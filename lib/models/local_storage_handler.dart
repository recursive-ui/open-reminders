import 'package:open_reminders/models/data_handler.dart';
import 'package:open_reminders/models/reminder.dart';
import 'package:localstore/localstore.dart';

class LocalStorageHandler extends DataHandler {
  late Localstore db;

  @override
  Future<void> addTask(Task newTask) async {
    // final String id = db.collection('reminders').doc().id;
    return db
        .collection('reminders')
        .doc(newTask.id.toString())
        .set(newTask.toJson());
  }

  @override
  Future<void> updateTask(Task taskData) {
    return db
        .collection('reminders')
        .doc(taskData.id.toString())
        .set(taskData.toJson());
  }

  @override
  Future<void> deleteTask(int taskId) async {
    return db.collection('reminders').doc(taskId.toString()).delete();
  }

  @override
  Future<List<Task>> readTasks() async {
    Map<String, dynamic>? map = await db.collection('reminders').get();
    if (map == null) {
      return [];
    }
    return map.entries.map((t) => Task.fromMap(t.value)).toList();
  }

  @override
  Future<void> initialise() async {
    db = Localstore.instance;
  }
}
