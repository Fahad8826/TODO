import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_todo/model/notification_sevice.dart';
import 'package:new_todo/view/loginpage.dart';
import 'package:new_todo/view/signup.dart';
import 'package:new_todo/view/userhomepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scheduled Notifications',
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
