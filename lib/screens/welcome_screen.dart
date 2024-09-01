import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:identify_attendance_app/screens/student_screen.dart';

import '../components/rounded_button.dart';
import 'lecturer_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const String routeName = 'welcome_screen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Opacity(
                opacity: 0.3,
                child: Container(
                    child: Image.asset(
                  'assets/images/UNIBEN-Logo.png',
                  height: 300,
                  width: 300,
                )),
              ),
              Text(
                'IDentify',
                style: GoogleFonts.lilitaOne(
                    color: Colors.blueGrey,
                    fontSize: 40.0,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 5.0,
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              Text(
                'Attendance App',
                style: GoogleFonts.abhayaLibre(
                  color: Colors.blueGrey,
                  fontSize: 20.0,
                  fontStyle: FontStyle.normal,
                  letterSpacing: 1.0,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 70.0,
              ),
              Text(
                'Please select as applicable',
                textAlign: TextAlign.center,
                style: TextStyle(
                  wordSpacing: 0.10,
                ),
              ),
              Column(
                children: [
                  RoundedButton(
                    onPress: () {
                      Navigator.pushNamed(context, StudentScreen.routeName);
                    },
                    colour: Colors.indigo,
                    label: 'Student',
                  ),
                  RoundedButton(
                    onPress: () {
                      Navigator.pushNamed(context, LecturerScreen.routeName);
                    },
                    colour: Colors.redAccent,
                    label: 'Lecturer',
                  )
                ],
              )
            ],
          )),
    );
  }
}
