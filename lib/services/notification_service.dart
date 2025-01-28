import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as notification;
import 'package:personal_task_manager/models/task_model.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final notification.FlutterLocalNotificationsPlugin _notifications =
      notification.FlutterLocalNotificationsPlugin();

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

    const notification.InitializationSettings initSettings =
        notification.InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse:
          (notification.NotificationResponse response) {
        // Handle notification tap
        print('Notification tapped: ${response.payload}');
      },
    );
  }

  Future<void> scheduleTaskNotification(TaskModel task) async {
    // Schedule notification for upcoming task
    await _notifications.zonedSchedule(
      task.id.hashCode, // Unique ID for the notification
      'Task Due Soon: ${task.title}',
      task.description,
      tz.TZDateTime.from(
        task.dueDate.subtract(Duration(hours: 1)), // Notify 1 hour before
        tz.local,
      ),
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
      payload: task.id,
      androidScheduleMode:
          notification.AndroidScheduleMode.exact, // Pass task ID as payload
    );
  }

  Future<void> cancelTaskNotification(TaskModel task) async {
    await _notifications.cancel(task.id.hashCode);
  }
}
