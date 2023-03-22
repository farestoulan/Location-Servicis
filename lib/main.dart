import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'bolc_obsever.dart';
import 'models/location.dart';
import 'my_app.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

main() async {
  // final _localNotificationService = FlutterLocalNotificationsPlugin();

  Bloc.observer = MyBlocObserver();

  // Initialize hive
  await Hive.initFlutter();
  Hive.registerAdapter(LocationAdapter());
  // Opening the box
  await Hive.openBox('locationBox');

  // Initialize Google Map
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = true;
  }
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();
// flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
//     AndroidFlutterLocalNotificationsPlugin>()!.requestPermission();
//     // Android & IOS Settings
//     const AndroidInitializationSettings androidInitializationSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     final DarwinInitializationSettings initializationSettingsDarwin =
//         DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//       onDidReceiveLocalNotification: onDidReceiveLocalNotification,
//     );
//     var initializationSettings = InitializationSettings(
//       android: androidInitializationSettings,
//       iOS: initializationSettingsDarwin,
//     );
//     await _localNotificationService.initialize(
//       initializationSettings,
//     );

  runApp(MyApp());
}
  // void onDidReceiveLocalNotification(
  //     int id, String? title, String? body, String? payload) {}
  //       Future<NotificationDetails> _notificationDetails() async {
  //   const AndroidNotificationDetails androidNotificationDetails =
  //       AndroidNotificationDetails(
  //     'channelId',
  //     'channelName',
  //     channelDescription: "description",
  //     importance: Importance.max,
  //     priority: Priority.max,
  //     playSound: true,
  //   );

  //   const DarwinNotificationDetails iosNotificationDetails =
  //       DarwinNotificationDetails();

  //   return const NotificationDetails(
  //     android: androidNotificationDetails,
  //     iOS: iosNotificationDetails,
  //   );
  // }
