import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';

class DatePickerModal extends StatefulWidget {
  const DatePickerModal({super.key});

  @override
  State<DatePickerModal> createState() => _DatePickerModalState();
}

class _DatePickerModalState extends State<DatePickerModal> {
  DateTime? date;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        children: [
          CalendarTimeline(
            initialDate: DateTime(2020, 4, 20),
            firstDate: DateTime(2019, 1, 15),
            lastDate: DateTime(2020, 11, 20),
            onDateSelected: (newDate) => date = newDate,
            leftMargin: 20,
            monthColor: Colors.blueGrey,
            dayColor: Colors.teal[200],
            activeDayColor: Colors.white,
            activeBackgroundDayColor: Colors.redAccent[100],
            dotsColor: Color(0xFF333A47),
            locale: 'en_ISO',
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
