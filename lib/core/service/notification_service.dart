import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todoapp/main.dart';

@pragma('vm:entry-point')
Future<void> handleBackgroudMessages(RemoteMessage remoteMessage) async {
  debugPrint('messageTitle: ${remoteMessage.notification?.title}');
  debugPrint('messageText: ${remoteMessage.notification?.body}');
}

class NotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  late AndroidNotificationChannel channel;

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initFirebaseMessaging() async {
    // TODO: request permission for using notification
    await _firebaseMessaging.requestPermission();

    // TODO: getting the device token from the fcm
    final fcmToken = await _firebaseMessaging.getToken();
    debugPrint('fcmTokens: $fcmToken');

    await setupFlutterNotifications();

    // handles notification when the app is in background
    FirebaseMessaging.onBackgroundMessage(handleBackgroudMessages);
    // handles notification when tapped from the notification when the app is terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      debugPrint('NOTIFICATION: terminated');
      redirectNotification(message);
    });
    // handles notification when tapped from the notification when the app is in for background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('NOTIFICATION: messageOpened');
      redirectNotification(message);
    });

    // handles the tapped action of the notification when app is foreground
    FirebaseMessaging.onMessage.listen((message) async {
      await showNotification(message);
    });
  }

  void redirectNotification(RemoteMessage? remoteMessage) {
    if (remoteMessage == null) return;
    final payload = jsonEncode({
      'notification': {
        'title': remoteMessage.notification?.title,
        'body': remoteMessage.notification?.body,
      },
      'data': remoteMessage.data,
    });
    navigatorKey.currentState?.pushNamed('/notification', arguments: payload);
  }

  Future<void> setupFlutterNotifications() async {
    final initializationSettingsAndroid = AndroidInitializationSettings(
      '@drawable/ic_launcher',
    );
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('📢 NOTIFICATION tapped in foreground: ${response.payload}');
        if (response.payload != '{}') {
          navigatorKey.currentState?.pushNamed(
            '/notification',
            arguments: response.payload,
          );
        }
      },
    );

    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> showNotification(RemoteMessage remoteMessage) async {
    final notification = remoteMessage.notification;
    final payload = jsonEncode({
      'notification': {
        'title': notification?.title,
        'body': notification?.body,
      },
      'data': remoteMessage.data,
    });

    if (notification == null) return;
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: '@drawable/ic_launcher',
        ),
      ),
      payload: payload,
    );
  }
}
