import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant/strings_manager.dart';

int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}

class NotificationDateAndTime {
  final int day;
  final int month;
  final int year;
  final TimeOfDay timeOfDay;

  NotificationDateAndTime({
    required this.day,
    required this.month,
    required this.year,
    required this.timeOfDay,
  });
}

class NotificationDayOfWeekAndTime {
  final int dayOfTheWeek;
  final TimeOfDay timeOfDay;

  NotificationDayOfWeekAndTime({
    required this.dayOfTheWeek,
    required this.timeOfDay,
  });
}

Future<bool> onBackButtonPressed(BuildContext context) async {
  bool exitApp = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppStrings.warning.tr()),
          content: Text(AppStrings.closeApp.tr()),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(AppStrings.no.tr())),
            TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text(AppStrings.yes.tr())),
          ],
        );
      });
  return exitApp;
}
