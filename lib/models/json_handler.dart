import 'dart:convert';
import 'dart:io';
import 'package:open_reminders/models/reminder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class JSONHandler {
  static Future<void> writeData(List<Task> tasks, String folderPath) async {
    List<Map> testMap = tasks.map((e) => e.toJson()).toList();
    final jsonData = jsonEncode(testMap);
    final file = File('$folderPath/reminders.json');
    await file.writeAsString(jsonData);
  }

  static Future<bool> isReadWriteAllowed(
      {bool requestPermission = false}) async {
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

  static Future<List<Task>> readData(String folderPath) async {
    // isReadWriteAllowed(requestPermission: true);

    String filePath = '$folderPath/reminders.json';

    if (!File(filePath).existsSync()) {
      File(filePath).createSync(recursive: true);
      return [];
    }

    String input = File(filePath).readAsStringSync();

    if (input == "") {
      return [];
    } else {
      List<dynamic> map = jsonDecode(input);
      return map.map((e) => Task.fromMap(e)).toList();
    }
  }

  static Future<String> getDefaultStorageDirectory() async {
    Directory folderPath = await getApplicationDocumentsDirectory();
    return folderPath.path;
  }
}
