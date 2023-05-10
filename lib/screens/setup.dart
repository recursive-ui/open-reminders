import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_reminders/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  String folderPath = 'Selected folder...';
  bool hasValidPath = false;

  void pickFolder() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      setState(() {
        folderPath = selectedDirectory;
        hasValidPath = true;
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('json_dir', selectedDirectory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Select a save folder',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 50.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: IconButton(
                            onPressed: pickFolder,
                            icon: const Icon(Icons.folder_open),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: GestureDetector(
                          onTap: pickFolder,
                          child: SizedBox(
                            height: 50.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    folderPath,
                                    style: TextStyle(
                                        color: ThemeColors.kOnSurface
                                            .withOpacity(0.5)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16.0),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                  child: Text(
                    'Pick a folder with existing saved tasks or select a folder to save new tasks in.',
                    style: TextStyle(
                        color: ThemeColors.kOnSurface.withOpacity(0.5)),
                  ),
                ),
              ],
            ),
            Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 32.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: hasValidPath
                      ? ThemeColors.kPrimary
                      : Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextButton(
                  onPressed: hasValidPath ? () {} : null,
                  child: Text(
                    'Continue',
                    style: TextStyle(
                        color: hasValidPath
                            ? ThemeColors.kOnSurface.withOpacity(0.5)
                            : ThemeColors.kOnPrimary),
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
