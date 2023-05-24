import 'package:flutter/material.dart';
import 'package:open_reminders/constants.dart';
import 'package:open_reminders/models/dialog_status.dart';
import 'package:open_reminders/models/reminder.dart';
import 'package:open_reminders/widgets/custom_reminder.dart';

class ReminderPickerModal extends StatefulWidget {
  const ReminderPickerModal({super.key});

  @override
  State<ReminderPickerModal> createState() => _ReminderPickerModalState();
}

class _ReminderPickerModalState extends State<ReminderPickerModal> {
  final List<Reminder> _items = [
    Reminder(),
    Reminder(duration: const Duration(minutes: 10)),
    Reminder(time: const TimeOfDay(hour: 9, minute: 0)),
    Reminder(duration: const Duration(days: 1)),
  ];
  final Map<String, bool> _checkedItems = {};

  @override
  void initState() {
    super.initState();
    for (Reminder item in _items) {
      _checkedItems[item.prettyName] = false;
    }
  }

  void _addItem(Reminder newItem) {
    setState(() {
      if (!_checkedItems.containsKey(newItem.prettyName)) {
        _items.add(newItem);
        _checkedItems[newItem.prettyName] = true;
      }
    });
  }

  void _onCheckboxChanged(String item, bool? isChecked) {
    if (isChecked != null) {
      setState(() {
        _checkedItems[item] = isChecked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> checkboxes = [];
    for (Reminder item in _items) {
      checkboxes.add(CheckboxListTile(
        title: Text(item.prettyName),
        dense: true,
        value: _checkedItems[item.prettyName],
        onChanged: (bool? isChecked) {
          _onCheckboxChanged(item.prettyName, isChecked);
        },
      ));
    }

    return AlertDialog(
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: checkboxes,
                ),
              ),
            ),
            CustomReminderInput(
              onTap: _addItem,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Clear',
            style: TextStyle(color: ThemeColors.kError),
          ),
          onPressed: () {
            Navigator.of(context).pop(DialogStatus(true, null));
          },
        ),
        TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(color: ThemeColors.kPrimary),
          ),
          onPressed: () {
            Navigator.of(context).pop(DialogStatus(false, null));
          },
        ),
        TextButton(
          child: const Text(
            'Ok',
            style: TextStyle(color: ThemeColors.kSecondary),
          ),
          onPressed: () {
            List<Reminder> outItems = [];
            for (Reminder item in _items) {
              if (_checkedItems[item.prettyName] == true) {
                outItems.add(item);
              }
            }
            Navigator.of(context).pop(DialogStatus(true, outItems));
          },
        ),
      ],
    );
  }
}
