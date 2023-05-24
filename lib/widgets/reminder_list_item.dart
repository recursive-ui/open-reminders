import 'package:flutter/material.dart';
import 'package:open_reminders/constants.dart';
import 'package:open_reminders/models/reminder.dart';
import 'package:open_reminders/utilities.dart';
import 'package:open_reminders/widgets/reminder_list_item_icon.dart';

class ReminderListItem extends StatefulWidget {
  const ReminderListItem({super.key, required this.task});
  final Task task;

  @override
  State<ReminderListItem> createState() => _ReminderListItemState();
}

class _ReminderListItemState extends State<ReminderListItem> {
  bool isExpanded = false;
  bool isCompleted = false;
  List<Widget> expandedFields = [Container()];

  @override
  Widget build(BuildContext context) {
    if (isExpanded) {
      expandedFields = [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Description: '),
              Text(widget.task.description ?? ''),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Category: '),
              Text(widget.task.category ?? ''),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.access_time,
                  size: 24, color: ThemeColors.kPrimary),
              const SizedBox(width: 4.0),
              Text(widget.task.date == null
                  ? ''
                  : prettyTime(TimeOfDay.fromDateTime(widget.task.date!))!),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.timer, size: 24, color: ThemeColors.kPrimary),
              const SizedBox(width: 4.0),
              Text(prettyDuration(widget.task.duration) ?? ''),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.repeat, size: 24, color: ThemeColors.kPrimary),
              const SizedBox(width: 4.0),
              Text(prettyDate(widget.task.date) ?? ''),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.alarm, size: 24, color: ThemeColors.kPrimary),
              const SizedBox(width: 4.0),
              Text(prettyDate(widget.task.date) ?? ''),
            ],
          ),
        ),
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
                        Checkbox(
                          value: isCompleted,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value != null) {
                                isCompleted = value;
                              }
                            });
                          },
                        ),
                        const SizedBox(width: 8.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 0),
                              child: Text(
                                widget.task.name,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                            isExpanded
                                ? Container()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
    );
  }
}
