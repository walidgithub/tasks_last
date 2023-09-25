import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:daily_tasks/task/shared/style/colors_manager.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../presentation/ui/homepage/homepage_view.dart';
import '../utils/utils.dart';

class NotificationService {
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/ic_launcher',
      [
        NotificationChannel(
          channelGroupKey: 'daily_tasks_channel',
          channelKey: 'daily_tasks_channel',
          channelName: 'Daily tasks notifications',
          channelDescription: 'Notification channel for daily tasks',
          defaultColor: ColorManager.primary,
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: true,
          locked: true,
          soundSource: 'resource://raw/notification_alarm',
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'daily_tasks_channel_group',
          channelGroupName: 'Group 1',
        )
      ],
      debug: true,

    );

    await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) async {
        if (!isAllowed) {
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  /// Use this method to detect when a new notification or a schedule is created
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationCreatedMethod');
  }

  /// Use this method to detect every time that a new notification is displayed
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationDisplayedMethod');
  }

  /// Use this method to detect if the user dismissed a notification
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onDismissActionReceivedMethod');
  }

  /// Use this method to detect when the user taps on a notification or action button
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    final payload = receivedAction.payload ?? {};

    if (payload["navigate"] == "true") {
      MyApp.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => HomePageView(),
        ),
      );
    }
  }

  static Future<void> showDayOfWeekAndTimeNotification({
    required final NotificationDayOfWeekAndTime notificationSchedule,
    required final String title,
    required final String body,
    required final int notificationId,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = true,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notificationId,
        channelKey: 'daily_tasks_channel',
        title: title,
        body: body,
        actionType: actionType,
        notificationLayout: notificationLayout,
        summary: summary,
        category: category,
        payload: payload,
        bigPicture: bigPicture,
      ),
      actionButtons: actionButtons,
      schedule: NotificationCalendar(
        weekday: notificationSchedule.dayOfTheWeek,
        hour: notificationSchedule.timeOfDay.hour,
        minute: notificationSchedule.timeOfDay.minute,
        second: 0,
        millisecond: 0,
        allowWhileIdle: true,
        repeats: true
      )
    );
  }

  static Future<void> showDateAndTimeNotification({
    required final NotificationDateAndTime notificationSchedule,
    required final int notificationId,
    required final String title,
    required final String body,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = true,
  }) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notificationId,
          channelKey: 'daily_tasks_channel',
          title: title,
          body: body,
          actionType: actionType,
          notificationLayout: notificationLayout,
          summary: summary,
          category: category,
          payload: payload,
          bigPicture: bigPicture,
        ),
        actionButtons: actionButtons,
        schedule: NotificationCalendar(
          day: notificationSchedule.day,
          month: notificationSchedule.month,
          year: notificationSchedule.year,
          hour: notificationSchedule.timeOfDay.hour,
          minute: notificationSchedule.timeOfDay.minute,
          second: 0,
          millisecond: 0,
          allowWhileIdle: true,
        )
    );
  }

  static Future<void> cancelNotifications() async {
    await AwesomeNotifications().cancel(2);
  }
}


