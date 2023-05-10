import 'package:flutter/material.dart';
import 'package:open_reminders/constants.dart';

class AddReminderIconButton extends StatelessWidget {
  const AddReminderIconButton({
    Key? key,
    required this.iconData,
    required this.onPressed,
    this.height = 28,
    this.width = 28,
    this.iconSize = 24,
    this.colour = ThemeColors.kPrimary,
    this.padding = const EdgeInsets.all(4.0),
  }) : super(key: key);
  final IconData iconData;
  final double? height;
  final double? width;
  final double? iconSize;
  final Color? colour;
  final EdgeInsets padding;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        height: height,
        width: width,
        child: IconButton(
          onPressed: onPressed,
          splashRadius: iconSize,
          padding: EdgeInsets.zero,
          icon: Icon(iconData, size: iconSize),
          color: colour,
        ),
      ),
    );
  }
}
