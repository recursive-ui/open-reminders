import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_reminders/constants.dart';
import 'package:open_reminders/models/task.dart';
import 'package:open_reminders/screens/home.dart';
import 'package:open_reminders/screens/setup.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

String initialRoute = '/';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? folderPath = prefs.getString('json_dir');
  if (folderPath != null) {
    initialRoute = '/home';
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TaskModel>(
      create: (_) => TaskModel(),
      child: MaterialApp(
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
