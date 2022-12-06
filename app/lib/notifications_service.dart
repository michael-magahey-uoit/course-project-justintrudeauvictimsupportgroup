import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();
  static final FlutterLocalNotificationsPlugin localNotifications = FlutterLocalNotificationsPlugin();
  factory NotificationService() {
    return _notificationService;
  }
  NotificationService._internal();

  Future<void> init() async {
    final AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(android: androidSettings);
    await localNotifications.initialize(initializationSettings);
  }

  Future<void> notify(String title, String body) async {
    const AndroidNotificationDetails channelSpecifics = 
      AndroidNotificationDetails(
        "queue",   
        "queue", 
        channelDescription: "Queue Manager", 
        importance: Importance.high,
        priority: Priority.high
    );

    await localNotifications.show(0, title, body, NotificationDetails(android: channelSpecifics));
  }
}
