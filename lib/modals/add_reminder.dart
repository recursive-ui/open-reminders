import 'package:flutter/material.dart';
import 'package:open_reminders/constants.dart';
import 'package:open_reminders/modals/date_picker_modal.dart';
import 'package:open_reminders/models/reminder.dart';
import 'package:open_reminders/widgets/add_reminder_button.dart';

class AddReminder extends StatefulWidget {
  const AddReminder({super.key});

  @override
  State<AddReminder> createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  final _formKey = GlobalKey<FormState>();
  bool expandForm = false;
  DateTime? date;
  List<DateTime>? times;
  Duration? duration;
  List<Reminder>? reminders;
  List<Repeat>? repeat;

  void showModal() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return const DatePickerModal();
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
                        onPressed: showModal,
                        iconData: Icons.date_range,
                      ),
                      AddReminderIconButton(
                        onPressed: showModal,
                        iconData: Icons.access_time,
                      ),
                      AddReminderIconButton(
                        onPressed: showModal,
                        iconData: Icons.timer,
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
