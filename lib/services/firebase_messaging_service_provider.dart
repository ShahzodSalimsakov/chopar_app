// import 'dart:io';
//
// import 'package:chopar_app/services/notification.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// class FirebaseMessagingServiceProvider {
//   static FirebaseMessagingServiceProvider _instance;
//
//   static final FirebaseMessaging _messaging = FirebaseMessaging();
//
//   static String _fcmToken;
//
//   // FILTH
//   static Function(int) callback;
//
//   Future<String> fcmToken() async {
//     return _fcmToken ??= await _messaging.getToken();
//   }
//
//   factory FirebaseMessagingServiceProvider() =>
//       _instance ??= FirebaseMessagingServiceProvider._();
//
//   FirebaseMessagingServiceProvider._() {
//     _messaging.configure(
//       onMessage: _onMessageMessageHandler,
//       onResume: _onResumeOnLaunchMessageHandler,
//       onLaunch: _onResumeOnLaunchMessageHandler,
//       onBackgroundMessage: Platform.isIOS ? null : _onBackgroundMessageHandler,
//     );
//
//     if (Platform.isIOS) {
//       _messaging.requestNotificationPermissions();
//     }
//
//     _messaging.getToken().then((token) => _fcmToken = token);
//   }
//
//   static Future<dynamic> _onMessageMessageHandler(
//       Map<String, dynamic> message) async {
//     final notification = _parseNotification(message);
//     if (notification != null) {
//       callback?.call(int.tryParse(notification.data?.amount ?? ''));
//     }
//   }
//
//   static Future<dynamic> _onResumeOnLaunchMessageHandler(
//       Map<String, dynamic> message) async {
//     final notification = _parseNotification(message);
//     if (notification != null) {
//       callback?.call(int.tryParse(notification.data?.amount ?? ''));
//     }
//   }
//
//   static Future<dynamic> _onBackgroundMessageHandler(
//       Map<String, dynamic> message) async {}
//
//   static Notification _parseNotification(Map<String, dynamic> message) {
//     Notification data;
//     if (Platform.isAndroid) {
//       data = Notification.fromJson(message, isIos: false);
//     } else if (Platform.isIOS) {
//       data = Notification.fromJson(message, isIos: true);
//     }
//     return data;
//   }
// }
