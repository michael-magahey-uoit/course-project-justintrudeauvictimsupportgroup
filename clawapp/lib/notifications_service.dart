import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

//Notification Handler
class NotificationService {
  //Keep track of notification plugin for future notification pushes.
  static final NotificationService _notificationService = NotificationService._internal();
  static final FlutterLocalNotificationsPlugin localNotifications = FlutterLocalNotificationsPlugin();
  static int notificationCount = 0;
  factory NotificationService() {
    return _notificationService;
  }
  NotificationService._internal();

  //Called on OnConnect from socket. Initializes the notification plugin
  Future<void> init() async {
    final AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(android: androidSettings);
    await localNotifications.initialize(initializationSettings);
  }

  //Our wrapper for pushing a notification. Allows for bypassing a lot of variable declarations
  //use the same channel and push a notification, then increment the notification count.
  Future<void> notify(String title, String body) async {
    const AndroidNotificationDetails channelSpecifics = 
      AndroidNotificationDetails(
        "queue",   
        "queue", 
        channelDescription: "Queue Manager", 
        importance: Importance.high,
        priority: Priority.high
    );

    await localNotifications.show(notificationCount, title, body, NotificationDetails(android: channelSpecifics));
    notificationCount += 1;
  }
}
