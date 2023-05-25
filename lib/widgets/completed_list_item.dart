import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_reminders/constants.dart';
import 'package:open_reminders/models/reminder.dart';
import 'package:open_reminders/models/task.dart';
import 'package:open_reminders/utilities.dart';
import 'package:open_reminders/widgets/reminder_list_item_icon.dart';
import 'package:provider/provider.dart';

class CompletedListItem extends StatefulWidget {
  const CompletedListItem({super.key, required this.task});
  final Task task;

  @override
  State<CompletedListItem> createState() => _CompletedListItemState();
}

class _CompletedListItemState extends State<CompletedListItem> {
  bool isExpanded = false;
  List<Widget> expandedFields = [Container()];

  void deleteTask() {
    TaskModel model = Provider.of<TaskModel>(context, listen: false);
    model.deleteTask(widget.task.id, deleteCompleted: true);
  }

  @override
  Widget build(BuildContext context) {
    if (isExpanded) {
      expandedFields = [
        widget.task.description == null
            ? Container()
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Description: '),
                    Text(widget.task.description ?? ''),
                  ],
                ),
              ),
        widget.task.category == null
            ? Container()
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Category: '),
                    Text(widget.task.category ?? ''),
                  ],
                ),
              ),
        widget.task.priority == null
            ? Container()
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Priority: '),
                    Text(widget.task.priority == null
                        ? ''
                        : widget.task.priority.toString()),
                  ],
                ),
              ),
        widget.task.date == null
            ? Container()
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.date_range,
                        size: 24, color: ThemeColors.kPrimary),
                    const SizedBox(width: 4.0),
                    Text(prettyDate(widget.task.date) ?? ''),
                  ],
                ),
              ),
        widget.task.date == null
            ? Container()
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.access_time,
                        size: 24, color: ThemeColors.kPrimary),
                    const SizedBox(width: 4.0),
                    Text(widget.task.date == null
                        ? ''
                        : prettyTime(
                            TimeOfDay.fromDateTime(widget.task.date!))!),
                  ],
                ),
              ),
        widget.task.duration == null
            ? Container()
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.timer,
                        size: 24, color: ThemeColors.kPrimary),
                    const SizedBox(width: 4.0),
                    Text(prettyDuration(widget.task.duration) ?? ''),
                  ],
                ),
              ),
        widget.task.repeat == null
            ? Container()
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.repeat,
                        size: 24, color: ThemeColors.kPrimary),
                    const SizedBox(width: 4.0),
                    Text(DateFormat('h:mm a EEE, MMM d, ' 'yy')
                        .format(widget.task.getNextRepeat() ?? DateTime.now())),
                  ],
                ),
              ),
        widget.task.reminders == null
            ? Container()
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.alarm,
                        size: 24, color: ThemeColors.kPrimary),
                    const SizedBox(width: 4.0),
                    Text(widget.task.reminders!
                        .map((e) => e.prettyName)
                        .toList()
                        .join(', ')),
                  ],
                ),
              ),
        const SizedBox(height: 4.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 38,
                child: Container(
                  decoration: BoxDecoration(
                    color: ThemeColors.kError,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: TextButton(
                    onPressed: deleteTask,
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        fontSize: 14,
                        color: ThemeColors.kOnError,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ];
    } else {
      expandedFields = [Container()];
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(2.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.task.name,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 0,
                                      ),
                                      child: Text(
                                        prettyDate(widget.task.completedOn) ??
                                            '',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: ThemeColors.kError,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              isExpanded
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ReminderIconDetails(
                                          text: prettyDate(widget.task.date),
                                          iconData: Icons.date_range,
                                          colour: ThemeColors.kPrimary,
                                        ),
                                        ReminderIconDetails(
                                          text: prettyTime(
                                              widget.task.date == null
                                                  ? null
                                                  : TimeOfDay.fromDateTime(
                                                      widget.task.date!)),
                                          iconData: Icons.access_time,
                                          colour: ThemeColors.kPrimary,
                                        ),
                                        ReminderIconDetails(
                                          text: widget.task.duration == null
                                              ? null
                                              : '',
                                          iconData: Icons.timer,
                                          colour: ThemeColors.kPrimary,
                                        ),
                                        ReminderIconDetails(
                                          text: widget.task.repeat == null
                                              ? null
                                              : '',
                                          iconData: Icons.repeat,
                                          colour: ThemeColors.kPrimary,
                                        ),
                                        ReminderIconDetails(
                                          text: widget.task.reminders == null
                                              ? null
                                              : '',
                                          iconData: Icons.alarm,
                                          colour: ThemeColors.kPrimary,
                                        )
                                      ],
                                    ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more),
                        onPressed: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                      ),
                    ],
                  ),
                ] +
                expandedFields,
          ),
        ),
      ),
    );
  }
}
