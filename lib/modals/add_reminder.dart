import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:open_reminders/constants.dart';
import 'package:open_reminders/modals/duration_picker_modal.dart';
import 'package:open_reminders/models/reminder.dart';
import 'package:open_reminders/utilities.dart';
import 'package:open_reminders/widgets/add_reminder_button.dart';
import 'package:open_reminders/widgets/duration_picker.dart';

class AddReminder extends StatefulWidget {
  const AddReminder({super.key});

  @override
  State<AddReminder> createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  final _formKey = GlobalKey<FormState>();
  bool expandForm = false;
  DateTime? date;
  TimeOfDay? time;
  Duration? duration;
  List<Reminder>? reminders;
  List<Repeat>? repeat;

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
    }
  }

  void showTimeOfDayPicker() async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        time = selectedTime;
      });
    }
  }

  void showDurationDialog() async {
    Duration? newDuration = await showDialog<Duration>(
      context: context,
      builder: (BuildContext context) {
        return const DurationPickerModal();
      },
    );

    if (newDuration != null) {
      setState(() {
        duration = newDuration;
      });
    }
  }

  void showModal() {
    showDialog<Duration>(
      context: context,
      builder: (BuildContext context) {
        return const DurationPickerModal();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                        decoration: const InputDecoration(
                          labelText: 'What do you want to do?',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        }),
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
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
              expandForm ? const SizedBox(height: 8.0) : Container(),
              expandForm
                  ? TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Category',
                      ),
                    )
                  : Container(),
              expandForm ? const SizedBox(height: 8.0) : Container(),
              expandForm
                  ? TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Tags',
                      ),
                    )
                  : Container(),
              expandForm ? const SizedBox(height: 8.0) : Container(),
              expandForm
                  ? TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Priority',
                      ),
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
                        onPressed: showModal,
                        iconData: Icons.repeat,
                      ),
                    ],
                  ),
                  AddReminderIconButton(
                    onPressed: () {},
                    iconData: Icons.send_outlined,
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
