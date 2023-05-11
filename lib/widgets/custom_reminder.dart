import 'package:flutter/material.dart';
import 'package:open_reminders/constants.dart';
import 'package:open_reminders/modals/duration_picker_modal.dart';
import 'package:open_reminders/utilities.dart';
import 'package:open_reminders/widgets/duration_picker.dart';
import 'package:open_reminders/widgets/number_picker.dart';

class CustomReminderInput extends StatefulWidget {
  const CustomReminderInput({super.key});

  @override
  State<CustomReminderInput> createState() => _CustomReminderInputState();
}

class _CustomReminderInputState extends State<CustomReminderInput> {
  TimeOfDay? time;
  Duration? duration;
  int daysBefore = 0;
  int hoursBefore = 0;
  int minutesBefore = 0;

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

  void showDurationDialog(BaseUnit baseUnit) async {
    Duration? newDuration = await showDialog<Duration>(
      context: context,
      builder: (BuildContext context) {
        return DurationPickerModal(
          onlyUseBaseUnit: baseUnit,
        );
      },
    );

    if (newDuration != null) {
      setState(() {
        duration = newDuration;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 35,
                child: Container(
                  decoration: BoxDecoration(
                    color: ThemeColors.kPrimary,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextButton(
                    onPressed: showTimeOfDayPicker,
                    child: const Text(
                      'At Time',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: ThemeColors.kOnPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: showTimeOfDayPicker,
                child: SizedBox(
                  height: 35,
                  child: Container(
                    decoration: BoxDecoration(
                      color: time != null
                          ? Colors.white.withOpacity(0.12)
                          : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Center(
                      child: Text(
                        prettierTime(time) ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14.0,
                            color: time != null
                                ? ThemeColors.kOnSurface.withOpacity(0.5)
                                : ThemeColors.kOnSurface),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        time != null
            ? Container()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 35,
                    width: 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: const Center(
                        child: Text(
                          'Mins before',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: ThemeColors.kOnSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  NumberPicker(
                    itemHeight: 35,
                    itemWidth: 50,
                    value: minutesBefore,
                    axis: Axis.horizontal,
                    textStyle: TextStyle(
                        color: ThemeColors.kOnSurface.withOpacity(0.7)),
                    selectedTextStyle:
                        const TextStyle(color: ThemeColors.kPrimary),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: ThemeColors.kPrimary),
                    ),
                    minValue: 0,
                    maxValue: 60,
                    onChanged: (value) => setState(() => minutesBefore = value),
                  ),
                ],
              ),
        time != null ? Container() : const SizedBox(height: 8.0),
        time != null
            ? Container()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 35,
                    width: 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: const Center(
                        child: Text(
                          'Hours before',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: ThemeColors.kOnSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  NumberPicker(
                    itemHeight: 35,
                    itemWidth: 50,
                    value: hoursBefore,
                    axis: Axis.horizontal,
                    textStyle: TextStyle(
                        color: ThemeColors.kOnSurface.withOpacity(0.7)),
                    selectedTextStyle:
                        const TextStyle(color: ThemeColors.kPrimary),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: ThemeColors.kPrimary),
                    ),
                    minValue: 0,
                    maxValue: 60,
                    onChanged: (value) => setState(() => hoursBefore = value),
                  ),
                ],
              ),
        time != null ? Container() : const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 35,
              width: 100,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: const Center(
                  child: Text(
                    'Days before',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: ThemeColors.kOnSurface,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            NumberPicker(
              itemHeight: 35,
              itemWidth: 50,
              value: daysBefore,
              axis: Axis.horizontal,
              textStyle:
                  TextStyle(color: ThemeColors.kOnSurface.withOpacity(0.7)),
              selectedTextStyle: const TextStyle(color: ThemeColors.kPrimary),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: ThemeColors.kPrimary),
              ),
              minValue: 0,
              maxValue: 60,
              onChanged: (value) => setState(() => daysBefore = value),
            ),
          ],
        ),
        const SizedBox(height: 32.0),
        SizedBox(
          height: 35,
          child: Container(
            decoration: BoxDecoration(
              color: ThemeColors.kSecondary,
              borderRadius: BorderRadius.circular(5.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: const Center(
              child: Text(
                'Add Custom',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                  color: ThemeColors.kOnSecondary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
