import 'package:flutter/material.dart';
import 'package:open_reminders/constants.dart';

class ReminderIconDetails extends StatelessWidget {
  const ReminderIconDetails({
    Key? key,
    required this.iconData,
    this.text,
    this.iconSize = 18,
    this.colour = ThemeColors.kPrimary,
    this.padding = const EdgeInsets.all(4.0),
  }) : super(key: key);
  final IconData iconData;
  final double iconSize;
  final Color? colour;
  final EdgeInsets padding;
  final String? text;

  Widget getWidget() {
    if (text == null) {
      return Container();
    } else if (text == '') {
      return Icon(
        iconData,
        size: iconSize,
        color: colour,
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(iconData, size: iconSize, color: colour),
          const SizedBox(width: 4.0),
          Text(text!, style: TextStyle(color: colour)),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: getWidget(),
    );
  }
}
