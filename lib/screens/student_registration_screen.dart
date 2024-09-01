import 'package:flutter/material.dart';
import 'package:identify_attendance_app/components/face_capture_widget.dart';
import 'package:identify_attendance_app/screens/student_login_page.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/rounded_button.dart';
import '../components/text_field._email.dart';
import '../components/text_field_name_phone.dart';
import '../components/text_field_password.dart';
import '../constants.dart';

class StudentRegistrationScreen extends StatefulWidget {
  static const String routeName = 'student_registration_screen';

  const StudentRegistrationScreen({super.key});

  @override
  _StudentRegistrationScreenState createState() =>
      _StudentRegistrationScreenState();
}

class _StudentRegistrationScreenState extends State<StudentRegistrationScreen> {
  bool showSpinner = false;
  late String email;
  late String password;
  late String name;
  late String matnumber;
  late String session;
  late String confirmPassword;
  late String department;
  late String level;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
        toolbarHeight: 40,
        title: const Text(
          'IDentify',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        titleSpacing: 4.0,
        shadowColor: Colors.white70,
        backgroundColor: Colors.blueAccent.withOpacity(0.8),
        foregroundColor: Colors.white70,
      ),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Image.asset('assets/images/init 2.jpeg'),
                    TextFieldNamePhone(
                      icon: const Icon(Icons.account_circle),
                      hintText: 'Enter your Full Name',
                      onChanged: (value) {
                        name = value;
                      },
                      color: kSignUpTextFieldColour,
                    ),
                    TextFieldNamePhone(
                      icon: const Icon(Icons.sort_by_alpha_rounded),
                      hintText: 'Enter your MatNO',
                      onChanged: (value) {
                        matnumber = value;
                      },
                      color: kSignUpTextFieldColour,
                    ),
                    TextFieldNamePhone(
                      icon: const Icon(Icons.sort_by_alpha_rounded),
                      hintText: 'Enter your current session',
                      onChanged: (value) {
                        session = value;
                      },
                      color: kSignUpTextFieldColour,
                    ),
                    TextFieldNamePhone(
                      icon: const Icon(Icons.sort_by_alpha_rounded),
                      hintText: 'Enter your department',
                      onChanged: (value) {
                        department = value;
                      },
                      color: kSignUpTextFieldColour,
                    ),
                    TextFieldNamePhone(
                      icon: const Icon(Icons.sort_by_alpha_rounded),
                      hintText: 'Enter your current level',
                      onChanged: (value) {
                        level = value;
                      },
                      color: kSignUpTextFieldColour,
                    ),
                    TextFieldEmail(
                      hintText: 'Enter Your Email',
                      icon: const Icon(Icons.email),
                      Onchanged: (value) {
                        email = value;
                      },
                      coloour: kSignUpTextFieldColour,
                    ),
                    PasswordTextField(
                      hintText: 'Enter Your Password',
                      icon: const Icon(Icons.lock),
                      onChanged: (value) {
                        password = value;
                      },
                      coloour: kSignUpTextFieldColour,
                    ),
                    PasswordTextField(
                      hintText: 'Confirm Password',
                      icon: const Icon(Icons.lock),
                      onChanged: (value) {
                        confirmPassword = value;
                      },
                      coloour: kSignUpTextFieldColour,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    RoundedButton(
                        colour: Colors.indigo,
                        onPress: () async {
                          if (_formKey.currentState!.validate()) {
                            if (password != confirmPassword) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Passwords do not match!'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            setState(() {
                              showSpinner = true;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FaceCaptureWidget(
                                    email: email,
                                    password: password,
                                    name: name,
                                    matnumber: matnumber,
                                    session: session,
                                    department: department,
                                    level: level),
                              ),
                            );
                          }
                        },
                        label: 'Sign Up'),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Have an account?",
                            style: TextStyle(color: kSignUpTextFieldColour),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, StudentLoginScreen.routeName);
                            },
                            child: const Text(
                              'Log in Here',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
