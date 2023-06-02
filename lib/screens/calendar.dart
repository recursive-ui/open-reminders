import 'package:flutter/material.dart';
import 'package:open_reminders/constants.dart';
import 'package:open_reminders/models/calendar_data.dart';
import 'package:open_reminders/models/task.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskModel>(
      builder: (context, taskModel, child) {
        DateTime now = DateTime.now();
        DateTime startDate = DateTime(now.year, now.month, 1);
        startDate.subtract(const Duration(days: 7));
        DateTime endDate = DateTime(now.year, now.month + 1, 14);

        List<Meeting> meetings =
            taskModel.meetings(startDate: startDate, endDate: endDate);
        return SfCalendar(
          dataSource: MeetingDataSource(meetings),
          view: CalendarView.month,
          appointmentTextStyle:
              const TextStyle(color: ThemeColors.kOnPrimary, fontSize: 12),
          monthViewSettings: const MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
        );
      },
    );
  }
}
