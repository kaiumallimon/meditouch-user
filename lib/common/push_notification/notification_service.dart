// import 'dart:developer';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class PushNotificationService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

//   // Initialize Firebase messaging and local notifications
//   Future<void> initialize() async {
//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//     // Set up initialization for local notifications
//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       android:
//           AndroidInitializationSettings('@mipmap/app_icon2'), // Your app icon
//     );
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);

//     // Create notification channel for Android (required for Android 8.0+)
//     await _createNotificationChannel();

//     // Request permission to receive notifications (iOS)
//     await _firebaseMessaging.requestPermission();

//     // Handle foreground notifications
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       if (message.notification != null) {
//         log("Handling a foreground message: ${message.messageId}");
//         _showNotification(message.notification!);
//       }
//     });

//     // Handle background and terminated state notifications
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//     // Get the device token (send to your server for targeting specific devices)
//     String? token = await _firebaseMessaging.getToken();
//     print("Device Token: $token");
//   }

//   // Function to create notification channel for Android 8.0 and above
//   Future<void> _createNotificationChannel() async {
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'high_importance_channel', // The id of the channel.
//       'High Importance Notifications', // The name of the channel.
//       description: 'This channel is used for important notifications.',
//       importance: Importance.high,
//     );

//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//   }

//   void _showNotification(RemoteNotification notification) {
//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: AndroidNotificationDetails(
//         'high_importance_channel',
//         'High Importance Notifications',
//         importance: Importance.high,
//         priority: Priority.high,
//       ),
//     );

//     flutterLocalNotificationsPlugin.show(
//       0,
//       notification.title,
//       notification.body,
//       notificationDetails,
//     );
//   }

//   // Handle background messages (app is in background or terminated)
//   static Future<void> _firebaseMessagingBackgroundHandler(
//       RemoteMessage message) async {
//     print("Handling a background message: ${message.data}");
//     // You can navigate to a specific screen or update the UI here
//   }
// }

import 'dart:io';
import 'package:timezone/timezone.dart' as tz;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meditouch/app/app_exporter.dart';

class FCMService {
  static void initialize() {
    FirebaseMessaging.onMessage.listen((message) {
      print("onMessage: ${message.notification!.title}");
      print("onMessage: ${message.notification!.body}");
    });

    // get device token
    FirebaseMessaging.instance.getToken().then((token) {
      print("Device Token: $token");
    });
  }
}

class NotificationService {
  final _flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();

  // Initialize local notifications
  void initLocalNotification(
      BuildContext context, RemoteMessage message) async {
    var android = AndroidInitializationSettings('@mipmap/app_icon2');
    var ios = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
      android: android,
      iOS: ios,
    );

    await _flutterLocalNotificationPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (details) {
      handleMessage(context, message);
    });
  }

  // firebase init
  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;

      AndroidNotification? android = message.notification?.android;

      if (kDebugMode) {
        print("onMessage: ${message.notification!.title}");
        print("onMessage: ${message.notification!.body}");
      }
      if (Platform.isIOS) {
        iosForegroundNotification();
      }
      if (Platform.isAndroid) {
        initLocalNotification(context, message);
        // handleMessage(context, message);
        showNotification(message);
      }
    });
  }

  // function to show notification
  // Example for null check and error handling in showNotification method:
  Future<void> showNotification(RemoteMessage message) async {
    try {
      if (message.notification != null) {
        // channel settings
        AndroidNotificationChannel channel = AndroidNotificationChannel(
          message.notification!.android!.channelId!.toString(),
          message.notification!.android!.channelId!.toString(),
          importance: Importance.high,
          showBadge: true,
          playSound: true,
        );

        // android settings
        AndroidNotificationDetails androidNotificationDetails =
            AndroidNotificationDetails(
          channel.id.toString(),
          channel.name.toString(),
          channelDescription: 'channelDescription',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: channel.sound,
        );

        // ios settings
        DarwinNotificationDetails iosNotificationDetails =
            const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

        // notification details
        NotificationDetails notificationDetails = NotificationDetails(
          android: androidNotificationDetails,
          iOS: iosNotificationDetails,
        );

        // show notification
        await _flutterLocalNotificationPlugin.show(
          message.hashCode,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails,
        );
      }
    } catch (e) {
      print("Error showing notification: $e");
    }
  }

  // background and terminated
  Future<void> setupInteractedMessage(BuildContext context) async {
    // background state
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });

    // terminated state
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null && message.data.isNotEmpty) {
        handleMessage(context, message);
      }
    });
  }

  Future<void> handleMessage(
      BuildContext context, RemoteMessage message) async {
    // call navigation bloc

    Navigator.of(context).pushNamed('/dashboard');
  }

  // iOS settings
  Future iosForegroundNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }


  // Future<void> scheduleNotification(
  //     {required DateTime startDate,
  //       required DateTime endDate,
  //       required TimeOfDay notificationTime,
  //       required String title,
  //       required String body}) async {
  //   try {
  //     // Get the local timezone
  //     final location = tz.local;
  //
  //     // Convert start and end dates to TZDateTime objects
  //     tz.TZDateTime startDateTime = tz.TZDateTime(
  //       location,
  //       startDate.year,
  //       startDate.month,
  //       startDate.day,
  //       notificationTime.hour,
  //       notificationTime.minute,
  //     );
  //
  //     tz.TZDateTime endDateTime = tz.TZDateTime(
  //       location,
  //       endDate.year,
  //       endDate.month,
  //       endDate.day,
  //       notificationTime.hour,
  //       notificationTime.minute,
  //     );
  //
  //     // Check if the start date is before the end date
  //     if (startDateTime.isAfter(endDateTime)) {
  //       print("Start date cannot be after the end date.");
  //       return;
  //     }
  //
  //     // Schedule notifications between start and end dates
  //     tz.TZDateTime currentTime = startDateTime;
  //     while (currentTime.isBefore(endDateTime)) {
  //       await _flutterLocalNotificationPlugin.zonedSchedule(
  //         currentTime.hashCode,
  //         title,
  //         body,
  //         currentTime,
  //
  //         const NotificationDetails(
  //           android: AndroidNotificationDetails(
  //             'high_importance_channel',
  //             'High Importance Notifications',
  //             importance: Importance.high,
  //             priority: Priority.high,
  //           ),
  //         ),
  //         // androidAllowWhileIdle: true,
  //         uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime, androidScheduleMode: AndroidScheduleMode.alarmClock,
  //       );
  //       currentTime = currentTime.add(Duration(days: 1)); // Schedule for next day
  //     }
  //   } catch (e) {
  //     print("Error scheduling notification: $e");
  //   }
  // }

}
