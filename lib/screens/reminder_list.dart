import 'package:flutter/material.dart';
import 'package:open_reminders/modals/add_reminder.dart';
import 'package:open_reminders/models/task.dart';
import 'package:provider/provider.dart';

class ReminderList extends StatelessWidget {
  const ReminderList({super.key});

  void addNewReminder(BuildContext context) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return const AddReminder();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskModel>(
      builder: (context, taskModel, child) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => addNewReminder(context),
            child: const Icon(Icons.add, size: 40.0),
          ),
          body: Column(
            children: [
                  Text(taskModel.filePath),
                ] +
                taskModel.tasks.entries.map((e) => Text(e.key)).toList(),
          ),
        );
      },
    );
  }
}
