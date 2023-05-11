import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_reminders/constants.dart';
import 'package:open_reminders/models/reminder.dart';
import 'package:open_reminders/widgets/repeat_picker_row.dart';

class RepeatPickerModal extends StatefulWidget {
  const RepeatPickerModal({super.key});

  @override
  State<RepeatPickerModal> createState() => _RepeatPickerModalState();
}

class _RepeatPickerModalState extends State<RepeatPickerModal> {
  final _formKey = GlobalKey<FormState>();

  List<DateTime>? testResults;
  TextEditingController minuteController = TextEditingController();
  TextEditingController hourController = TextEditingController();
  TextEditingController dayController = TextEditingController();
  TextEditingController weekdayController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  RepeatType minutePicker = RepeatType.value;
  RepeatType hourPicker = RepeatType.value;
  RepeatType dayPicker = RepeatType.any;
  RepeatType weekdayPicker = RepeatType.value;
  RepeatType monthPicker = RepeatType.value;

  Repeat createRepeat() {
    return Repeat(
      minutes: minuteController.text == ''
          ? null
          : RepeatValue.fromString(minutePicker, minuteController.text),
      hours: hourController.text == ''
          ? null
          : RepeatValue.fromString(hourPicker, hourController.text),
      days: dayController.text == ''
          ? null
          : RepeatValue.fromString(dayPicker, dayController.text),
      weekdays: weekdayController.text == ''
          ? null
          : RepeatValue.fromString(weekdayPicker, weekdayController.text),
      months: monthController.text == ''
          ? null
          : RepeatValue.fromString(monthPicker, monthController.text),
    );
  }

  @override
  void initState() {
    super.initState();
    minuteController.text = '0';
    hourController.text = '9';
    setState(() {
      testResults = createRepeat().getNextNDates(3);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RepeatPickerRow(
                  labelText: 'Minutes',
                  controller: minuteController,
                  value: minutePicker,
                  onChanged: (newValue) {
                    setState(() {
                      if (newValue != null) {
                        minutePicker = newValue;
                      }
                    });
                  },
                ),
                RepeatPickerRow(
                  labelText: 'Hours',
                  controller: hourController,
                  value: hourPicker,
                  onChanged: (newValue) {
                    setState(() {
                      if (newValue != null) {
                        hourPicker = newValue;
                      }
                    });
                  },
                ),
                RepeatPickerRow(
                  labelText: 'Days',
                  controller: dayController,
                  value: dayPicker,
                  onChanged: (newValue) {
                    setState(() {
                      if (newValue != null) {
                        dayPicker = newValue;
                      }
                    });
                  },
                ),
                RepeatPickerRow(
                  labelText: 'Week Days',
                  controller: weekdayController,
                  value: weekdayPicker,
                  onChanged: (newValue) {
                    setState(() {
                      if (newValue != null) {
                        weekdayPicker = newValue;
                      }
                    });
                  },
                ),
                RepeatPickerRow(
                  labelText: 'Months',
                  controller: monthController,
                  value: monthPicker,
                  onChanged: (newValue) {
                    setState(() {
                      if (newValue != null) {
                        monthPicker = newValue;
                      }
                    });
                  },
                ),
                const SizedBox(height: 32.0),
                testResults == null
                    ? Container()
                    : Column(
                        children: [
                          const Text(
                            'Next 3 Instances',
                            style: TextStyle(
                              color: ThemeColors.kPrimary,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            DateFormat('h:mm a EEE, MMM d, ' 'yy')
                                .format(testResults![0]),
                            style: const TextStyle(fontSize: 12.0),
                          ),
                          Text(
                            DateFormat('h:mm a EEE, MMM d, ' 'yy')
                                .format(testResults![1]),
                            style: const TextStyle(fontSize: 12.0),
                          ),
                          Text(
                            DateFormat('h:mm a EEE, MMM d, ' 'yy')
                                .format(testResults![2]),
                            style: const TextStyle(fontSize: 12.0),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Test',
            style: TextStyle(color: ThemeColors.kPrimary),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              setState(() {
                testResults = createRepeat().getNextNDates(3);
              });
            } else {
              setState(() {
                testResults = null;
              });
            }
          },
        ),
        TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(color: ThemeColors.kError),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text(
            'Ok',
            style: TextStyle(color: ThemeColors.kSecondary),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(createRepeat());
            }
          },
        ),
      ],
    );
  }
}
