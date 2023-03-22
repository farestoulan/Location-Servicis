import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_demo/screens/locations/location_screen.dart';
import 'network/remote/services.dart';

late final LocalNotificationService notificationService;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    notificationService = LocalNotificationService();
    notificationService.inialize();
    super.initState();
  }

  @override
  void dispose() {
    // Closes all Hive boxes
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      debugShowCheckedModeBanner: false,
      // home: LocationAppExample(),
      home: LocationScreen(),
    );
  }
}
