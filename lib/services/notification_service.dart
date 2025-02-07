import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as notification;
import 'package:personal_task_manager/models/task_model.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final notification.FlutterLocalNotificationsPlugin _notifications =
      notification.FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveNotification(
      notification.NotificationResponse notificationResponse) async {}

  Future<void> initialize() async {
    tz.initializeTimeZones();

    // Initialize notification settings for Android
    const notification.AndroidInitializationSettings androidSettings =
        notification.AndroidInitializationSettings('@mipmap/ic_launcher');

    // Initialize notification settings for iOS
    const notification.DarwinInitializationSettings iOSSettings =
        notification.DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    //Combine Android and Ios initialization settings
    const notification.InitializationSettings initSettings =
        notification.InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    try {
      // Request permissions first
      await _notifications
          .resolvePlatformSpecificImplementation<
              notification.AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotification,
        onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification,
      );
    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }

  Future<void> scheduleTaskNotification(TaskModel task) async {
    // Ensure the notification time is in the future
    tz.TZDateTime scheduledDate = tz.TZDateTime.from(task.dueDate, tz.local);
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      print('Cannot schedule notification for past date');
      return;
    }

    // Schedule notification for upcoming task
    try {
      await _notifications.zonedSchedule(
        task.id.hashCode, // Unique ID for the notification
        'Task Due Soon: ${task.title}',
        task.description,
        scheduledDate,
        notification.NotificationDetails(
          android: notification.AndroidNotificationDetails(
            'task_reminders',
            'Task Reminders',
            channelDescription: 'Notifications for task reminders',
            importance: notification.Importance.high,
            priority: notification.Priority.high,
          ),
          iOS: notification.DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        uiLocalNotificationDateInterpretation:
            notification.UILocalNotificationDateInterpretation.absoluteTime,
        payload: task.id.toString(), // Convert ID to string
        androidScheduleMode: notification
            .AndroidScheduleMode.exactAllowWhileIdle, // Pass task ID as payload
      );
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }

  Future<void> cancelTaskNotification(TaskModel task) async {
    try {
      await _notifications.cancel(task.id.hashCode);
    } catch (e) {
      print('Error canceling notification: $e');
    }
  }
}
