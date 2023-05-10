import 'package:flutter/material.dart';
import 'package:open_reminders/constants.dart';
import 'package:open_reminders/widgets/duration_picker.dart';

class DurationPickerModal extends StatefulWidget {
  const DurationPickerModal({super.key});

  @override
  State<DurationPickerModal> createState() => _DurationPickerModalState();
}

class _DurationPickerModalState extends State<DurationPickerModal> {
  Duration _duration = const Duration(hours: 0, minutes: 0);
  BaseUnit baseUnit = BaseUnit.minute;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: DurationPicker(
                duration: _duration,
                baseUnit: baseUnit,
                onChange: (val) {
                  setState(() => _duration = val);
                },
                snapToMins: 5.0,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: baseUnit == BaseUnit.minute
                        ? Colors.white.withOpacity(0.08)
                        : Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        baseUnit = BaseUnit.minute;
                      });
                    },
                    child: Text(
                      'Minutes',
                      style: TextStyle(
                          color: baseUnit == BaseUnit.minute
                              ? ThemeColors.kOnSurface
                              : ThemeColors.kOnSurface.withOpacity(0.08)),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Container(
                  decoration: BoxDecoration(
                    color: baseUnit == BaseUnit.hour
                        ? Colors.white.withOpacity(0.08)
                        : Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        baseUnit = BaseUnit.hour;
                      });
                    },
                    child: Text(
                      'Hours',
                      style: TextStyle(
                          color: baseUnit == BaseUnit.hour
                              ? ThemeColors.kOnSurface
                              : ThemeColors.kOnSurface.withOpacity(0.08)),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
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
            Navigator.of(context).pop(_duration);
          },
        ),
      ],
    );
  }
}
