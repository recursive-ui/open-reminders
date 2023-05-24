import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_reminders/constants.dart';
import 'package:open_reminders/models/dialog_status.dart';
import 'package:open_reminders/models/reminder.dart';
import 'package:open_reminders/widgets/repeat_picker_row.dart';
import 'package:open_reminders/widgets/repeat_picker_weekday_row.dart';

class RepeatPickerModal extends StatefulWidget {
  const RepeatPickerModal({super.key, this.repeat});

  final Repeat? repeat;

  @override
  State<RepeatPickerModal> createState() => _RepeatPickerModalState();
}

class _RepeatPickerModalState extends State<RepeatPickerModal> {
  final _formKey = GlobalKey<FormState>();

  List<DateTime>? testResults;
  List<int>? selectedWeekdays;
  List<bool> isCheckedDaysOfWeek = List.filled(7, false);
  TextEditingController minuteController = TextEditingController();
  TextEditingController hourController = TextEditingController();
  TextEditingController dayController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  RepeatType minutePicker = RepeatType.value;
  RepeatType hourPicker = RepeatType.value;
  RepeatType dayPicker = RepeatType.value;
  RepeatType monthPicker = RepeatType.value;

  void checkDayOfWeek(index) {
    setState(() {
      isCheckedDaysOfWeek[index] = !isCheckedDaysOfWeek[index];
    });
  }

  Repeat createRepeat() {
    selectedWeekdays = [];
    for (var i = 0; i < 7; i++) {
      if (isCheckedDaysOfWeek[i]) {
        selectedWeekdays?.add(i);
      }
    }

    if (selectedWeekdays!.isEmpty) {
      selectedWeekdays = null;
    }

    return Repeat(
      minutes: minuteController.text == '' && minutePicker != RepeatType.any
          ? null
          : RepeatValue.fromString(minutePicker, minuteController.text),
      hours: hourController.text == '' && hourPicker != RepeatType.any
          ? null
          : RepeatValue.fromString(hourPicker, hourController.text),
      days: dayController.text == '' && dayPicker != RepeatType.any
          ? null
          : RepeatValue.fromString(dayPicker, dayController.text),
      weekdays: selectedWeekdays == null
          ? null
          : RepeatValue(RepeatType.value, value: selectedWeekdays),
      months: monthController.text == '' && monthPicker != RepeatType.any
          ? null
          : RepeatValue.fromString(monthPicker, monthController.text),
    );
  }

  @override
  void dispose() {
    minuteController.dispose();
    hourController.dispose();
    dayController.dispose();
    monthController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.repeat == null) {
      minuteController.text = '0';
      hourController.text = '9';
      dayPicker = RepeatType.any;
    } else {
      Map<String, RepeatValue> initialRepeat = widget.repeat!.toRepeatValueMap;
      minuteController.text = initialRepeat['minutes']?.value == null
          ? ''
          : initialRepeat['minutes']!.value!.join(',');
      hourController.text = initialRepeat['hours']?.value == null
          ? ''
          : initialRepeat['hours']!.value!.join(',');
      dayController.text = initialRepeat['days']?.value == null
          ? ''
          : initialRepeat['days']!.value!.join(',');
      monthController.text = initialRepeat['months']?.value == null
          ? ''
          : initialRepeat['months']!.value!.join(',');

      if (initialRepeat['weekdays']?.value != null) {
        for (int weekday in initialRepeat['weekdays']!.value!) {
          isCheckedDaysOfWeek[weekday] = true;
        }
      }

      minutePicker = initialRepeat['minutes']?.type ?? RepeatType.value;
      hourPicker = initialRepeat['hours']?.type ?? RepeatType.value;
      dayPicker = initialRepeat['days']?.type ?? RepeatType.any;
      monthPicker = initialRepeat['months']?.type ?? RepeatType.value;
    }
    testResults = createRepeat().getNextNDates(3);
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
                  labelText: 'Days of Month',
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
                RepeatPickerWeekdayRow(
                  selectedWeekdays: isCheckedDaysOfWeek,
                  changeWeekday: checkDayOfWeek,
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
            'Clear',
            style: TextStyle(color: ThemeColors.kError),
          ),
          onPressed: () {
            Navigator.of(context).pop(DialogStatus(true, null));
          },
        ),
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
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(DialogStatus(true, createRepeat()));
            }
          },
        ),
      ],
    );
  }
}
