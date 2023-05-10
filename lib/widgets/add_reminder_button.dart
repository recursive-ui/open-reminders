import 'package:flutter/material.dart';
import 'package:open_reminders/constants.dart';

class AddReminderIconButton extends StatelessWidget {
  const AddReminderIconButton({
    Key? key,
    required this.iconData,
    required this.onPressed,
    this.text,
    this.iconSize = 24,
    this.colour = ThemeColors.kPrimary,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 8.0,
      vertical: 4.0,
    ),
  }) : super(key: key);
  final IconData iconData;
  final double iconSize;
  final Color? colour;
  final EdgeInsets padding;
  final void Function()? onPressed;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: text == null
          ? GestureDetector(
              onTap: onPressed,
              child: Icon(
                iconData,
                size: iconSize,
                color: colour,
              ),
            )
          : GestureDetector(
              onTap: onPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(iconData, size: iconSize, color: colour),
                  const SizedBox(width: 4.0),
                  Text(text!, style: TextStyle(color: colour)),
                ],
              ),
            ),
    );
  }
}
