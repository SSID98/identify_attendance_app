import 'package:flutter/material.dart';

import '../components/rounded_button.dart';
import 'lecturer_login_screen.dart';
import 'lecturer_registration_screen.dart';

class LecturerScreen extends StatelessWidget {
  const LecturerScreen({super.key});

  static const String routeName = 'lecturer_screen';

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
              Container(child: Image.asset('assets/images/Lecturer.png')),
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
                          context, LecturerLoginScreen.routeName);
                    },
                    colour: Colors.redAccent,
                    label: 'Log In',
                  ),
                  RoundedButton(
                    onPress: () {
                      Navigator.pushNamed(
                          context, LecturerRegistrationScreen.routeName);
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
