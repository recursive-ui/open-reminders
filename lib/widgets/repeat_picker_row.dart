import 'package:flutter/material.dart';
import 'package:open_reminders/models/reminder.dart';
import 'package:open_reminders/utilities.dart';
import 'package:open_reminders/widgets/repeat_picker_dropdown.dart';

class RepeatPickerRow extends StatefulWidget {
  const RepeatPickerRow({
    super.key,
    required this.value,
    required this.labelText,
    required this.controller,
    this.onChanged,
  });
  final RepeatType value;
  final String labelText;
  final TextEditingController controller;
  final void Function(RepeatType?)? onChanged;

  @override
  State<RepeatPickerRow> createState() => _RepeatPickerRowState();
}

class _RepeatPickerRowState extends State<RepeatPickerRow> {
  String extraHint() {
    switch (widget.value) {
      case RepeatType.value:
        return ' e.g. 1, 2, 5';
      case RepeatType.range:
        return ' e.g. 5-10';
      case RepeatType.increment:
        return ' e.g. every 15mins';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: 2,
          child: RepeatPickerDropDown(
            value: widget.value,
            onChanged: widget.onChanged,
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          flex: 3,
          child: TextFormField(
            enabled: widget.value != RepeatType.any,
            controller: widget.controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: widget.labelText + extraHint(),
              labelStyle: const TextStyle(fontSize: 14.0),
            ),
            validator: (input) {
              switch (widget.value) {
                case RepeatType.any:
                  return null;
                case RepeatType.value:
                  return validatorListValuesField(input);
                case RepeatType.range:
                  return validatorRangeField(input);
                default:
                  return validatorNumericField(input);
              }
            },
          ),
        ),
      ],
    );
  }
}
