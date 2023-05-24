import 'package:flutter/material.dart';

class RepeatPickerWeekdayRow extends StatefulWidget {
  const RepeatPickerWeekdayRow({
    super.key,
    required this.selectedWeekdays,
    required this.changeWeekday,
  });
  final List<bool> selectedWeekdays;
  final void Function(int) changeWeekday;

  @override
  State<RepeatPickerWeekdayRow> createState() => _RepeatPickerWeekdayRowState();
}

class _RepeatPickerWeekdayRowState extends State<RepeatPickerWeekdayRow> {
  double fontSize = 10;
  final List<String> daysOfWeek = [
    'Sun',
    'Mon',
    'Tues',
    'Wed',
    'Thurs',
    'Fri',
    'Sat'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 24, bottom: 8, left: 0, right: 16),
          child: Container(
            padding: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              color: Colors.white.withOpacity(0.2),
              width: 1.0,
            ))),
            child: const Text(
              'Weekdays',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(7, (index) {
              return Column(
                children: [
                  Checkbox(
                      visualDensity: VisualDensity.compact,
                      value: widget.selectedWeekdays[index],
                      onChanged: (value) => widget.changeWeekday(index)),
                  Text(daysOfWeek[index], style: TextStyle(fontSize: fontSize))
                ],
              );
            }),
          ),
        )
      ],
    );
  }
}
