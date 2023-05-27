import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:open_reminders/constants.dart';
import 'package:open_reminders/models/task.dart';
import 'package:open_reminders/screens/completed_list.dart';
import 'package:open_reminders/screens/reminder_list.dart';
import 'package:open_reminders/screens/settings.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _widgetOptions = <Widget>[
    ReminderList(),
    Text('Index 1: Calendar'),
    CompletedReminderList(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final receivedAction =
        ModalRoute.of(context)!.settings.arguments as ReceivedAction?;

    if (receivedAction != null) {
      TaskModel model = Provider.of<TaskModel>(context, listen: false);
      int? taskId = int.tryParse(receivedAction.payload!['id']!);
      if (taskId != null) {
        if (receivedAction.buttonKeyPressed == 'complete') {
          model.completeTask(taskId);
        } else if (receivedAction.buttonKeyPressed == 'snooze') {
          model.snoozeTask(taskId);
        }
      }
    }

    return SafeArea(
        child: Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Reminders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: 'Completed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: ThemeColors.kPrimary,
        selectedFontSize: 12.0,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
      ),
    ));
  }
}
