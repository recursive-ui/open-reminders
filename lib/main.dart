import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_reminders/constants.dart';
import 'package:open_reminders/models/notifications.dart';
import 'package:open_reminders/models/task.dart';
import 'package:open_reminders/screens/home.dart';
import 'package:open_reminders/screens/setup.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

String initialRoute = '/';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? folderPath = prefs.getString('data_directory');
  if (folderPath != null) {
    initialRoute = '/home';
  }

  AwesomeNotifications().initialize(
      null,
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
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
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
      child: MaterialApp(
        navigatorKey: MyApp.navigatorKey,
        title: 'Open Reminders',
        theme: _buildTheme(Brightness.dark),
        initialRoute: initialRoute,
        routes: {
          '/': ((context) => const SetupScreen()),
          '/home': ((context) => const HomeScreen()),
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
