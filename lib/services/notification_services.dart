import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:firebase_database/firebase_database.dart';

class NotificationService extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("Users");

  Future initialize() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings("ic_launcher");

    //IOS local notification initialize
    DarwinInitializationSettings iosSettings =
        const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true,
      requestSoundPermission: true,
    );

    InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    bool? initialized = await flutterLocalNotificationsPlugin
        .initialize(initializationSettings, onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) {
      final String? payload = notificationResponse.payload;
      if (notificationResponse.payload != null) {
        debugPrint('notification payload: $payload');
      }
    });

    log("Notifications: $initialized");
  }

// Future stylishNotification(List day) async {
//     String message = "Your Appointment is sheduled on " +
//         day.toString();
//     var android = AndroidNotificationDetails("id", "channel", "description",
//         color: Colors.deepOrange,
//         enableLights: true,
//         enableVibration: true,
//         largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
//         styleInformation: MediaStyleInformation(
//             htmlFormatContent: true, htmlFormatTitle: true));

//     var platform = new NotificationDetails(android: android);

//     await notificationsPlugin.show(
//         0, 'Doctor Appointment', message, platform);
//   }

  Future<void> showLowNotification(String plantName) async {
    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
            "notifications-flutter", "Flutter Notifications",
            priority: Priority.high,
            importance: Importance.max,
            largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
            ticker: 'ticker',
            playSound: true,
            enableVibration: true);

    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notiDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    DateTime scheduleDate = DateTime.now().add(Duration(seconds: 1));

    await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        "Notification for $plantName",
        "Plant Moisture is low : Starting Motor Now",
        tz.TZDateTime.from(scheduleDate, tz.local),
        notiDetails,
        payload: 'Default_Sound',
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> showHighNotification(String plantName) async {
    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
            "notifications-flutter", "Flutter Notifications",
            priority: Priority.high,
            importance: Importance.max,
            largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
            ticker: 'ticker',
            playSound: true,
            enableVibration: true);

    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notiDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    DateTime scheduleDate = DateTime.now().add(Duration(seconds: 1));

    await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        "Notification for $plantName",
        "Plant is watered : Motor Stopped",
        tz.TZDateTime.from(scheduleDate, tz.local),
        notiDetails,
        payload: 'Default_Sound',
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void checkForNotification() async {
    NotificationAppLaunchDetails? details =
        await _flutterLocalNotificationsPlugin
            .getNotificationAppLaunchDetails();

    if (details != null) {
      if (details.didNotificationLaunchApp) {
        NotificationResponse? response = details.notificationResponse;

        if (response != null) {
          String? payload = response.payload;
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (_) => DashBoard(uid: widget.uid)));
        }
      }
    }
  }
}
