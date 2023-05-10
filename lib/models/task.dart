import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_reminders/models/reminder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskModel extends ChangeNotifier {
  Map<String, Task> tasks = {};
  String filePath = '';

  TaskModel() {
    _initModel();
  }

  Future<void> _initModel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? folderPath = prefs.getString('json_dir');
    filePath = '$folderPath/reminders.json';
    if (!File(filePath).existsSync()) {
      File(filePath).createSync(recursive: true);
      tasks = {};
    } else {
      String input = File(filePath).readAsStringSync();
      if (input == "") {
        tasks = {};
      } else {
        Map map = jsonDecode(input);
        tasks = map.map((key, value) => MapEntry(key, Task.fromMap(value)));
      }
    }
    notifyListeners();
  }
}
