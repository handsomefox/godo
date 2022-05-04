import 'package:flutter/material.dart';
import 'package:frontend/models/task_model.dart';
import 'package:intl/intl.dart';

class TaskCardWidget extends StatelessWidget {
  TaskCardWidget({Key? key, required this.task}) : super(key: key);

  final Task task;
  final DateFormat _formatter = DateFormat();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 24.0,
        horizontal: 32.0,
      ),
      decoration: BoxDecoration(
        color: getCardColor(context),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            task.name,
            style: getTitleTextStyle(context),
          ),
          Text(
            task.desc,
            style: getTextStyle(context),
          ),
          Text(
            task.due != null ? _formatter.format(task.due as DateTime) : '',
            style: getOtherDateTextStyle(context),
          ),
        ],
      ),
    );
  }

  Color getCardColor(BuildContext context) {
    switch (Theme.of(context).brightness) {
      case Brightness.dark:
        return Colors.grey.shade900;
      case Brightness.light:
        return Colors.white;
    }
  }

  TextStyle getTextStyle(BuildContext context) {
    Color textColor = Theme.of(context).colorScheme.onBackground;
    return TextStyle(
      color: textColor,
      fontSize: 14.0,
    );
  }

  TextStyle getTitleTextStyle(BuildContext context) {
    Color textColor = Theme.of(context).colorScheme.onBackground;
    return TextStyle(
      color: textColor,
      fontSize: 22.0,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle getOtherDateTextStyle(BuildContext context) {
    Color textColor;
    switch (Theme.of(context).brightness) {
      case Brightness.dark:
        textColor = Colors.white54;
        break;
      case Brightness.light:
        textColor = Colors.black54;
        break;
    }

    return TextStyle(
      color: textColor,
      fontSize: 12.0,
    );
  }
}
