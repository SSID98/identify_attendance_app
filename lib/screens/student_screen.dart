import 'package:flutter/material.dart';
import 'package:identify_attendance_app/screens/student_registration_screen.dart';

import '../components/rounded_button.dart';
import 'student_login_page.dart';

class StudentScreen extends StatelessWidget {
  const StudentScreen({Key? key}) : super(key: key);

  static const String routeName = 'student_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(child: Image.asset('assets/images/init 1.png')),
              Text(
                'Hi Student!',
                style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                'login or sign up to continue',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                    color: Colors.black),
              ),
              Column(
                children: [
                  RoundedButton(
                    onPress: () {
                      Navigator.pushNamed(
                          context, StudentLoginScreen.routeName);
                    },
                    colour: Colors.redAccent,
                    label: 'Log In',
                  ),
                  RoundedButton(
                    onPress: () {
                      Navigator.pushNamed(
                          context, StudentRegistrationScreen.routeName);
                    },
                    colour: Colors.indigo,
                    label: 'Sign Up',
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
