import 'package:flutter/material.dart';
import 'package:open_reminders/models/reminder.dart';

class RepeatPickerDropDown extends StatelessWidget {
  const RepeatPickerDropDown({super.key, this.value, this.onChanged});
  final void Function(RepeatType?)? onChanged;
  final RepeatType? value;
  final double fontSize = 12.0;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<RepeatType>(
      value: value,
      isDense: true,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      iconSize: 18.0,
      onChanged: onChanged,
      items: [
        DropdownMenuItem<RepeatType>(
          value: RepeatType.any,
          child: Text('Every', style: TextStyle(fontSize: fontSize)),
        ),
        DropdownMenuItem<RepeatType>(
          value: RepeatType.range,
          child: Text('Range', style: TextStyle(fontSize: fontSize)),
        ),
        DropdownMenuItem<RepeatType>(
          value: RepeatType.value,
          child: Text('On', style: TextStyle(fontSize: fontSize)),
        ),
        DropdownMenuItem<RepeatType>(
          value: RepeatType.increment,
          child: Text('Increment', style: TextStyle(fontSize: fontSize)),
        ),
      ],
    );
  }
}
