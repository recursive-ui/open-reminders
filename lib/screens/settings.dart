import 'package:flutter/material.dart';
import 'package:open_reminders/constants.dart';
import 'package:open_reminders/models/json_handler.dart';
import 'package:open_reminders/models/task.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void exportReminders() async {
    TaskModel model = Provider.of<TaskModel>(context, listen: false);
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      JSONHandler.writeData(model.tasks, selectedDirectory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 50.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: ThemeColors.kPrimary,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: TextButton(
                      onPressed: exportReminders,
                      child: const Text(
                        'Export Reminders',
                        style: TextStyle(color: ThemeColors.kOnPrimary),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
