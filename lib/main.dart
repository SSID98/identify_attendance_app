import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:identify_attendance_app/components/course_provider.dart';
import 'package:identify_attendance_app/components/session_provider.dart';
import 'package:identify_attendance_app/routes.dart';
import 'package:identify_attendance_app/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

import 'constants.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CourseProvider(),
        ),
        ChangeNotifierProvider(create: (context) => SessionProvider())
      ],
      child: MaterialApp(
        title: 'IDentify',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
            //scaffold default color
            scaffoldBackgroundColor: kPrimaryColor,
            primaryColor: kPrimaryColor),
        initialRoute: WelcomeScreen.routeName,
        routes: routes,
      ),
    );
  }
}
