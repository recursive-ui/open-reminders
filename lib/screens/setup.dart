import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_reminders/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  String folderPath = 'Select a folder...';
  bool hasValidPath = false;
  bool isNotificationsAllowed = false;
  bool isStorageAllowed = false;

  void pickFolder() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      setState(() {
        folderPath = selectedDirectory;
        hasValidPath = true;
      });
    }
  }

  Future<bool> allowStorage() async {
    PermissionStatus permissionStatus = await Permission.storage.status;
    if (permissionStatus.isDenied) {
      await Permission.storage.request();
    } else if (permissionStatus.isPermanentlyDenied) {
      await openAppSettings();
    }

    permissionStatus = await Permission.storage.status;
    if (permissionStatus.isGranted) {
      try {
        String filePath = '$folderPath/reminders_temp.json';
        File(filePath).createSync();
        File(filePath).deleteSync();
        return true;
      } catch (e) {
        String? selectedDirectory = await FilePicker.platform
            .getDirectoryPath(initialDirectory: folderPath);
        if (selectedDirectory != null) {
          return false;
        }
      }
    }
    return false;
  }

  Future<bool> checkStorage() async {
    if (folderPath != '' || folderPath != 'Select a folder...') {
      final permissionStatus = await Permission.storage.status;
      if (!permissionStatus.isGranted) {
        return false;
      }
      try {
        String filePath = '$folderPath/reminders_temp.json';
        File(filePath).createSync();
        File(filePath).deleteSync();
        return true;
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  void allowNotifications() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications()
            .requestPermissionToSendNotifications()
            .then((didAllow) {
          setState(() => isNotificationsAllowed = didAllow);
        });
      } else {
        setState(() => isNotificationsAllowed = true);
      }
    });
  }

  void saveSetup() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('data_directory', folderPath);
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      folderPath = '/storage/emulated/0/Documents';
      setState(() => hasValidPath = true);
    } else {
      getApplicationDocumentsDirectory().then(
        (appDir) {
          setState(() {
            folderPath = appDir.path;
            hasValidPath = true;
          });
        },
      );
    }

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      setState(() {
        isNotificationsAllowed = isAllowed;
      });
    });

    checkStorage().then((value) {
      setState(() {
        isStorageAllowed = value;
      });
    });
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
                                    folderPath.replaceAll(
                                        "/storage/emulated/0", ""),
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
                const SizedBox(width: 16.0),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 50.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: !isStorageAllowed
                              ? ThemeColors.kPrimary
                              : Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: TextButton(
                          onPressed: isStorageAllowed
                              ? () {}
                              : () {
                                  allowStorage().then((value) {
                                    setState(() {
                                      isStorageAllowed = value;
                                    });
                                  });
                                },
                          child: Text(
                            'Allow Access To Storage',
                            style: TextStyle(
                                color: !isNotificationsAllowed
                                    ? ThemeColors.kOnSurface.withOpacity(0.5)
                                    : ThemeColors.kOnPrimary),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 50.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: !isNotificationsAllowed
                              ? ThemeColors.kPrimary
                              : Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: TextButton(
                          onPressed: isNotificationsAllowed
                              ? () {}
                              : allowNotifications,
                          child: Text(
                            'Allow Notifications',
                            style: TextStyle(
                                color: !isNotificationsAllowed
                                    ? ThemeColors.kOnSurface.withOpacity(0.5)
                                    : ThemeColors.kOnPrimary),
                          ),
                        ),
                      ),
                    ),
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
                  color:
                      hasValidPath && isNotificationsAllowed && isStorageAllowed
                          ? ThemeColors.kPrimary
                          : Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextButton(
                  onPressed:
                      hasValidPath && isNotificationsAllowed && isStorageAllowed
                          ? () {
                              saveSetup();
                              Navigator.pushNamed(context, '/home');
                            }
                          : null,
                  child: Text(
                    'Continue',
                    style: TextStyle(
                        color: hasValidPath &&
                                isNotificationsAllowed &&
                                isStorageAllowed
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
