import 'dart:developer';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:handmade_ecommerce_app/core/services/notification_service.dart';
import 'package:handmade_ecommerce_app/features/notifications/models/notifications_model.dart';

// Background message handler must be a top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("Handling a background message: ${message.messageId}");
}

class FCMService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Request permission for iOS/Android 13+
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    log('User granted permission: ${settings.authorizationStatus}');

    // Initialize Local Notifications for foreground display
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInitSettings =
        DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    await _localNotificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (details) {
        log('Notification clicked: ${details.payload}');
        if (details.payload != null && details.payload!.isNotEmpty) {
          try {
            final data = jsonDecode(details.payload!);
            final typeStr = data['type'] as String?;
            final targetId = data['targetId'] as String?;

            NotificationType? type;
            for (var val in NotificationType.values) {
              if (val.name == typeStr) {
                type = val;
                break;
              }
            }
            if (type == null) {
              try {
                final typeInt = int.parse(typeStr ?? '');
                type = NotificationType.values[typeInt];
              } catch (_) {}
            }

            if (type != null) {
              final dummyNotification = NotificationModel(
                id: data['id']?.toString() ?? '',
                title: '',
                body: '',
                type: type,
                createdAt: DateTime.now(),
                targetId: targetId,
              );
              NotificationService.handleNotificationTap(dummyNotification);
            }
          } catch (e) {
            log('Error parsing notification click payload: $e');
          }
        }
      },
    );

    // Setup Background Handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Setup Foreground Handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Received foreground message: ${message.notification?.title}');
      _showLocalNotification(message);
    });
  }

  static Future<String?> getToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      log('FCM Token: $token');
      return token;
    } catch (e) {
      log('Failed to get FCM token: $e');
      return null;
    }
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      await _localNotificationsPlugin.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription: 'This channel is used for important notifications.',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  }

  /// Show a local push notification directly (for mock/simulator or client-side sync testing)
  static Future<void> showTestNotification({
    required String title,
    required String body,
    required String type,
    required String targetId,
  }) async {
    await _localNotificationsPlugin.show(
      id: title.hashCode ^ body.hashCode,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'This channel is used for important notifications.',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode({
        'type': type,
        'targetId': targetId,
      }),
    );
  }
}
