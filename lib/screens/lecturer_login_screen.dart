import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:identify_attendance_app/screens/lecturer_profile_screen.dart';
import 'package:identify_attendance_app/screens/lecturer_registration_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/rounded_button.dart';
import '../components/text_field._email.dart';
import '../components/text_field_password.dart';
import '../constants.dart';

// this is for the login page
class LecturerLoginScreen extends StatefulWidget {
  static const String routeName = 'lecturer_login_screen';

  @override
  _LecturerLoginScreenState createState() => _LecturerLoginScreenState();
}

class _LecturerLoginScreenState extends State<LecturerLoginScreen> {
  bool showSpinner = false;
  late String email;
  late String password;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
        title: Text(
          'IDentify',
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        titleSpacing: 4.0,
        shadowColor: Colors.white70,
        backgroundColor: Colors.red.withOpacity(0.3),
        foregroundColor: Colors.white70,
      ),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Opacity(
                    opacity: 0.3,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                          child: Image.asset(
                        'assets/images/UNIBEN-Logo.png',
                        height: 300,
                        width: 300,
                      )),
                    ),
                  ),
                  TextFieldEmail(
                    hintText: 'Enter Your Email',
                    icon: Icon(Icons.email),
                    Onchanged: (value) {
                      email = value;
                    },
                    coloour: kLoginTextFieldColour,
                  ),
                  PasswordTextField(
                    hintText: 'Enter Your Password',
                    icon: Icon(Icons.lock),
                    onChanged: (value) {
                      password = value;
                    },
                    coloour: kLoginTextFieldColour,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  RoundedButton(
                      colour: Colors.redAccent,
                      onPress: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          final existingUser =
                              await _auth.signInWithEmailAndPassword(
                                  email: email, password: password);
                          if (existingUser != null) {
                            Navigator.pushNamed(
                                context, LecturerProfilePage.routeName);
                          }
                          setState(() {
                            showSpinner = false;
                          });
                        } catch (e) {
                          print(e);
                        }
                      },
                      label: 'Log in'),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account ?",
                        style: TextStyle(color: kLoginTextFieldColour),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, LecturerRegistrationScreen.routeName);
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
