import 'package:flutter/material.dart';
import 'package:open_reminders/models/reminder.dart';
import 'package:open_reminders/models/task.dart';
import 'package:open_reminders/widgets/completed_list_item.dart';
import 'package:provider/provider.dart';

class CompletedReminderList extends StatelessWidget {
  const CompletedReminderList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskModel>(
      builder: (context, taskModel, child) {
        List<Task> tasks = taskModel.completeTasks;

        return Scaffold(
          body: tasks.isEmpty
              ? const ListTile(
                  title: Text('Nothing completed yet..'),
                )
              : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return CompletedListItem(task: tasks[index]);
                  },
                ),
        );
      },
    );
  }
}
