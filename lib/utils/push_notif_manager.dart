import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habido_app/utils/globals.dart';
import 'func.dart';
import 'shared_pref.dart';

PushNotifManager pushNotifManager = PushNotifManager();

class PushNotifManager {
  late FirebaseApp firebaseApp;
  late FirebaseMessaging messaging;
  FlutterLocalNotificationsPlugin? localNotif;
  AndroidNotificationChannel? notifChannel; // Local notification

  init() async {
    ///
    /// Firebase app
    ///
    firebaseApp = await Firebase.initializeApp();

    ///
    /// Firebase messaging
    ///
    messaging = FirebaseMessaging.instance;
    if (Platform.isIOS) {
      messaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
    }

    ///
    /// Notification permission
    ///
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    ///
    /// Push notification token
    ///
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      var currentToken = SharedPref.getPushNotifToken();
      print('Push notif token: ' + currentToken + '\n');
      if (Func.isEmpty(currentToken)) {
        var newToken = await messaging.getToken(); // getToken(vapidKey: "BGpdLRs......"
        if (newToken != null) {
          print(newToken);
          SharedPref.setPushNotifToken(newToken);
        }
      }
    }

    ///
    /// Local notification
    ///
    if (Platform.isAndroid) {
      var initSettings = InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher'));

      localNotif = FlutterLocalNotificationsPlugin();
      await localNotif?.initialize(initSettings, onSelectNotification: (payload) async {
        if (payload != null) {
          print('notification payload: ' + payload);
        }
        // selectNotificationSubject.add(payload);
      });

      notifChannel = AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description: 'This channel is used for important notifications.', // description
        importance: Importance.max,
      );

      await localNotif?.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(notifChannel!);
      print('Local notif initialized');
    }

    ///
    /// Background message handler
    ///
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    ///
    /// Foreground message handler
    ///
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Logging
      print('Got a message whilst in the foreground! \n Message data: ${message.data}');
      if (message.notification != null) print('Message also contained a notification: ${message.notification}');

      ///
      /// Show local notification
      ///
      if (Platform.isAndroid) {
        _showLocalNotif(message);
      }
    });
  }

  _showLocalNotif(RemoteMessage message) async {
    try {
      RemoteNotification? notification = message.notification;
      AndroidNotification? androidNotif = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null) {
        if (notifChannel != null) {
          var notifDetail = NotificationDetails(
            android: AndroidNotificationDetails(notifChannel!.id, notifChannel!.name, channelDescription: notifChannel!.description, icon: androidNotif?.smallIcon),
          );

          await localNotif?.show(0, notification.title ?? '', notification.body ?? '', notifDetail, payload: 'item x');
        }
      }
    } catch (e) {
      print(e);
    }
  }
}

// Note: Function заавал тусдаа, class-ын гадна байх ёстой
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  globals.unreadNotifCount > 0 ? FlutterAppBadger.updateBadgeCount(globals.unreadNotifCount + globals.calendarBadgeCount) : FlutterAppBadger.removeBadge();
  print('Handling a background message ${message.messageId}');
}
