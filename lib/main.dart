import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_reminders/constants.dart';
import 'package:open_reminders/models/notifications.dart';
import 'package:open_reminders/models/task.dart';
import 'package:open_reminders/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
      'resource://drawable/notification_icon',
      [
        NotificationChannel(
            channelGroupKey: 'open_reminders_group',
            channelKey: 'open_reminders',
            channelName: 'Open Reminders',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: ThemeColors.kPrimary,
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'open_reminders_group',
            channelGroupName: 'Open Reminders Group')
      ],
      debug: true);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);

    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TaskModel>(
      create: (_) => TaskModel(),
      builder: (context2, _) => MaterialApp(
        navigatorKey: MyApp.navigatorKey,
        title: 'Open Reminders',
        theme: _buildTheme(Brightness.dark),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          if (settings.arguments != null) {
            final receivedAction = settings.arguments as ReceivedAction;

            int? taskId = int.tryParse(receivedAction.payload!['id']!);
            if (taskId != null) {
              TaskModel model = Provider.of<TaskModel>(context2, listen: false);
              print('test');
              if (receivedAction.buttonKeyPressed == 'complete') {
                model.completeTask(taskId);
              } else if (receivedAction.buttonKeyPressed == 'snooze') {
                model.snoozeTask(taskId);
              }
            }
          }

          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                  builder: (context) => const HomeScreen());
            default:
              return null;
          }
        },
      ),
    );
  }
}

ThemeData _buildTheme(brightness) {
  var baseTheme = ThemeData(
    brightness: brightness,
    colorScheme: const ColorScheme.dark(
      primary: ThemeColors.kPrimary,
      onPrimary: ThemeColors.kOnPrimary,
      background: ThemeColors.kBackground,
      onBackground: ThemeColors.kOnBackground,
      secondary: ThemeColors.kSecondary,
      onSecondary: ThemeColors.kOnSecondary,
      error: ThemeColors.kError,
      onError: ThemeColors.kOnError,
      surface: ThemeColors.kSurface,
      onSurface: ThemeColors.kOnSurface,
    ),
    scaffoldBackgroundColor: ThemeColors.kBackground,
    primaryColor: ThemeColors.kPrimary,
  );

  return baseTheme.copyWith(
    textTheme: GoogleFonts.robotoSlabTextTheme(baseTheme.textTheme),
  );
}
