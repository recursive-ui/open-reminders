import 'package:flutter/material.dart';
import 'package:open_reminders/modals/add_reminder.dart';
import 'package:open_reminders/models/reminder.dart';
import 'package:open_reminders/models/task.dart';
import 'package:open_reminders/widgets/reminder_list_item.dart';
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
        List<Task> tasks = taskModel.incompleteTasks;
        tasks.sort((a, b) {
          int compare = a.name.compareTo(b.name);
          if (a.date != null && b.date != null) {
            compare = a.date!.compareTo(b.date!);
            if (compare == 0) {
              return a.name.compareTo(b.name);
            }
          }
          return compare;
        });

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => addNewReminder(context),
            child: const Icon(Icons.add, size: 40.0),
          ),
          body: tasks.isEmpty
              ? const ListTile(
                  title: Text('Add a task to get started.'),
                )
              : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return ReminderListItem(task: tasks[index]);
                  },
                ),
        );
      },
    );
  }
}
