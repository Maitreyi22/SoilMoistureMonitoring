import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:soilmoisture/pages/welcomescreen.dart';
import 'package:soilmoisture/services/notification_services.dart';
import 'package:timezone/data/latest_10y.dart' as tz;
// import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  tz.initializeTimeZones();
  await NotificationService().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Soil Moisture Sensor',
        // routes: <String, WidgetBuilder>{
        //   '/dashboard': (BuildContext context) => const DashBoard()
        // },

        theme: ThemeData(
          fontFamily: 'Nunito',
        ),
        debugShowCheckedModeBanner: false,
        home: const WelcomeScreen());
  }
}
