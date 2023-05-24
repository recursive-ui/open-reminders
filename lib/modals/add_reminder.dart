import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_reminders/constants.dart';
import 'package:open_reminders/modals/duration_picker_modal.dart';
import 'package:open_reminders/modals/reminder_picker_modal.dart';
import 'package:open_reminders/modals/repeat_picker_modal.dart';
import 'package:open_reminders/models/dialog_status.dart';
import 'package:open_reminders/models/reminder.dart';
import 'package:open_reminders/models/task.dart';
import 'package:open_reminders/utilities.dart';
import 'package:open_reminders/widgets/add_reminder_button.dart';
import 'package:open_reminders/widgets/text_field_tags.dart';
import 'package:provider/provider.dart';
import 'package:textfield_tags/textfield_tags.dart';

class AddReminder extends StatefulWidget {
  const AddReminder({super.key, this.task, this.isEditing = false});

  final bool isEditing;
  final Task? task;

  @override
  State<AddReminder> createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  final _formKey = GlobalKey<FormState>();
  bool expandForm = false;
  String? name;
  String? description;
  int? priority;
  List<String>? tags;
  String? category;
  DateTime? date;
  TimeOfDay? time;
  Duration? duration;
  List<Reminder>? reminders;
  Repeat? repeat;

  final TextfieldTagsController _controller = TextfieldTagsController();

  void showCalendarPicker() async {
    double height = MediaQuery.of(context).size.height * 0.5;
    double width = MediaQuery.of(context).size.width * 0.9;
    List<DateTime?>? results = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        selectedDayHighlightColor: ThemeColors.kPrimary,
      ),
      dialogSize: Size(width, height),
      borderRadius: BorderRadius.circular(2),
    );
    if (results != null) {
      if (results.isNotEmpty) {
        setState(() {
          date = results[0];
        });
      }
    } else {
      setState(() {
        date = null;
      });
    }
  }

  void showTimeOfDayPicker() async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    setState(() {
      time = selectedTime;
    });
  }

  void showDurationDialog() async {
    DialogStatus<Duration?>? newDuration =
        await showDialog<DialogStatus<Duration?>>(
      context: context,
      builder: (BuildContext context) {
        return const DurationPickerModal();
      },
    );

    if (newDuration != null) {
      if (newDuration.isValid) {
        setState(() {
          duration = newDuration.data;
        });
      }
    }
  }

  void showRepeatModal() async {
    DialogStatus<Repeat?>? newRepeat = await showDialog<DialogStatus<Repeat?>>(
      context: context,
      builder: (BuildContext context) {
        return RepeatPickerModal(repeat: repeat);
      },
    );

    if (newRepeat != null) {
      if (newRepeat.isValid) {
        setState(() {
          repeat = newRepeat.data;
        });
      }
    }
  }

  void showReminderModal() async {
    DialogStatus<List<Reminder>?>? newReminders =
        await showDialog<DialogStatus<List<Reminder>?>>(
      context: context,
      builder: (BuildContext context) {
        return const ReminderPickerModal();
      },
    );

    if (newReminders != null) {
      if (newReminders.isValid) {
        setState(() {
          reminders = newReminders.data;
        });
      }
    }
  }

  void addReminderTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        tags = _controller.getTags;
      } catch (e) {
        tags = null;
      }

      time ??= const TimeOfDay(hour: 9, minute: 0);
      if (date != null) {
        date = DateTime(
          date!.year,
          date!.month,
          date!.day,
          time!.hour,
          time!.minute,
        );
      }

      Task newTask = Task(
        name!,
        description: description == '' ? null : description,
        date: date,
        duration: duration,
        reminders: reminders,
        repeat: repeat,
        priority: priority,
        tags: tags,
        category: category == '' ? null : category,
      );
      TaskModel model = Provider.of<TaskModel>(context, listen: false);
      model.addTask(newTask);

      if (widget.isEditing && widget.task != null) {
        model.deleteTask(widget.task!.id);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      name = widget.task!.name;
      description = widget.task!.description;
      priority = widget.task!.priority;

      tags = widget.task!.tags;
      if (tags != null) {
        if (tags!.isNotEmpty) {
          for (String tag in tags!) {
            _controller.addTag = tag;
          }
        }
      }

      category = widget.task!.category;
      date = widget.task!.date;
      time = widget.task!.date == null
          ? null
          : TimeOfDay.fromDateTime(widget.task!.date!);
      duration = widget.task!.duration;
      reminders = widget.task!.reminders;
      repeat = widget.task!.repeat;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double distanceToField = MediaQuery.of(context).size.width;

    return Form(
      key: _formKey,
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: name,
                      decoration: const InputDecoration(
                        labelText: 'What do you want to do?',
                      ),
                      onSaved: (newValue) => name = newValue,
                      validator: validatorForMissingFields,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        expandForm = !expandForm;
                      });
                    },
                    splashRadius: 28,
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.expand, size: 28.0),
                    color: ThemeColors.kPrimary,
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                onSaved: (newValue) => description = newValue,
              ),
              expandForm ? const SizedBox(height: 8.0) : Container(),
              expandForm
                  ? TextFormField(
                      initialValue: category,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                      ),
                      onSaved: (newValue) => category = newValue,
                    )
                  : Container(),
              expandForm ? const SizedBox(height: 8.0) : Container(),
              expandForm
                  ? DefaultTextFieldTags(
                      controller: _controller, distanceToField: distanceToField)
                  : Container(),
              expandForm ? const SizedBox(height: 8.0) : Container(),
              expandForm
                  ? TextFormField(
                      initialValue: priority?.toString(),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Priority',
                      ),
                      onSaved: (newValue) => priority =
                          newValue == null ? null : int.tryParse(newValue),
                    )
                  : Container(),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AddReminderIconButton(
                        text: prettyDate(date),
                        onPressed: showCalendarPicker,
                        iconData: Icons.date_range,
                        colour: date == null
                            ? Colors.white.withOpacity(0.24)
                            : ThemeColors.kPrimary,
                      ),
                      AddReminderIconButton(
                        text: prettyTime(time),
                        onPressed: showTimeOfDayPicker,
                        iconData: Icons.access_time,
                        colour: time == null
                            ? Colors.white.withOpacity(0.24)
                            : ThemeColors.kPrimary,
                      ),
                      AddReminderIconButton(
                        text: prettyDuration(duration),
                        onPressed: showDurationDialog,
                        iconData: Icons.timer,
                        colour: duration == null
                            ? Colors.white.withOpacity(0.24)
                            : ThemeColors.kPrimary,
                      ),
                      AddReminderIconButton(
                        onPressed: showRepeatModal,
                        iconData: Icons.repeat,
                        colour: repeat == null
                            ? Colors.white.withOpacity(0.24)
                            : ThemeColors.kPrimary,
                      ),
                      AddReminderIconButton(
                        onPressed: showReminderModal,
                        iconData: Icons.alarm,
                        colour: reminders == null
                            ? Colors.white.withOpacity(0.24)
                            : ThemeColors.kPrimary,
                      ),
                    ],
                  ),
                  AddReminderIconButton(
                    onPressed: addReminderTask,
                    iconData:
                        widget.isEditing ? Icons.save : Icons.send_outlined,
                    colour: ThemeColors.kSecondary,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
