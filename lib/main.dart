import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_todo/model/Authentication_service.dart';
import 'package:new_todo/model/notification_sevice.dart';
import 'package:new_todo/view/AuthenticatedHomePage.dart';
import 'package:new_todo/view/loginpage.dart';
import 'package:new_todo/view/userhomepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initNotification();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService authService = AuthService();
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      home: FutureBuilder(
        future: authService.getLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            bool isLoggedIn = snapshot.data as bool;
            return isLoggedIn ? HomePage() : Loginpage();
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
