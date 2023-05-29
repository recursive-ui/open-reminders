import 'dart:convert';
import 'dart:io';
import 'package:open_reminders/models/data_handler.dart';
import 'package:open_reminders/models/reminder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer';

class JSONHandler extends DataHandler {
  late String folderPath;
  List<Task> _tasks = [];

  @override
  Future<void> addTask(Task newTask) {
    _tasks.add(newTask);
    return writeData(_tasks, folderPath);
  }

  @override
  Future<void> deleteTask(int taskId) {
    _tasks.removeWhere((e) => e.id == taskId);
    return writeData(_tasks, folderPath);
  }

  @override
  Future<List<Task>> readTasks() async {
    String filePath = '$folderPath/reminders.json';

    if (!File(filePath).existsSync()) {
      File(filePath).createSync(recursive: true);
      return [];
    }

    String input = File(filePath).readAsStringSync();

    if (input != "") {
      try {
        List<dynamic> map = jsonDecode(input);
        _tasks = map.map((e) => Task.fromMap(e)).toList();
      } on FormatException {
        log(input);
      }
    }
    return _tasks;
  }

  static Future<void> writeData(List<Task> tasks, String folderPath) async {
    List<Map> testMap = tasks.map((e) => e.toJson()).toList();
    final jsonData = jsonEncode(testMap);
    final file = File('$folderPath/reminders.json');
    await file.writeAsString(jsonData);
  }

  Future<bool> isReadWriteAllowed({bool requestPermission = false}) async {
    PermissionStatus permissionStatus =
        await Permission.manageExternalStorage.status;
    if (permissionStatus.isDenied) {
      if (requestPermission) {
        await Permission.manageExternalStorage.request();
      }
    } else if (permissionStatus.isPermanentlyDenied) {
      if (requestPermission) {
        await openAppSettings();
      }
    }

    return false;
  }

  @override
  Future<void> initialise() async {
    Directory applicationDir = await getApplicationDocumentsDirectory();
    folderPath = applicationDir.path;
  }
}
