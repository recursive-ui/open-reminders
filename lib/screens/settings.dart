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
  bool usePrecise = false;

  void togglePreciseNotifications() {
    TaskModel model = Provider.of<TaskModel>(context, listen: false);
    setState(() {
      usePrecise = !usePrecise;
    });
    model.setPreciseNotifications(usePrecise);
  }

  void exportReminders() async {
    TaskModel model = Provider.of<TaskModel>(context, listen: false);
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      JSONHandler.writeData(model.tasks, selectedDirectory);
    }
  }

  @override
  void initState() {
    super.initState();
    TaskModel model = Provider.of<TaskModel>(context, listen: false);
    usePrecise = model.usePreciseNotifications;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
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
            ),
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
                      onPressed: togglePreciseNotifications,
                      child: Text(
                        usePrecise
                            ? 'Stop Precise Reminders'
                            : 'Use Precise Reminders',
                        style: const TextStyle(color: ThemeColors.kOnPrimary),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 32,
                  right: 32,
                  top: 0,
                  bottom: 16,
                ),
                child: Text(
                  'Note that this can use more battery and only affects new reminders after this has been enabled.',
                  style: TextStyle(
                    color: ThemeColors.kOnBackground.withOpacity(0.7),
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
