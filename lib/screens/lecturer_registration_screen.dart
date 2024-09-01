import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:identify_attendance_app/screens/lecturer_profile_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/alert_dialog_widget.dart';
import '../components/rounded_button.dart';
import '../components/text_field._email.dart';
import '../components/text_field_name_phone.dart';
import '../components/text_field_password.dart';
import '../constants.dart';
import 'lecturer_login_screen.dart';

class LecturerRegistrationScreen extends StatefulWidget {
  static const String routeName = 'lecturer_registration_screen';

  const LecturerRegistrationScreen({super.key});

  @override
  _LecturerRegistrationScreenState createState() =>
      _LecturerRegistrationScreenState();
}

class _LecturerRegistrationScreenState
    extends State<LecturerRegistrationScreen> {
  bool showSpinner = false;
  late String email;
  late String password;
  late String confirmPassword;
  late String name;
  List<Map<String, String>> courseDetails = []; // List to hold course details
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
        shadowColor: Colors.white.withOpacity(1.0),
        backgroundColor: Colors.blueAccent.withOpacity(0.4),
        foregroundColor: Colors.white,
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
                    Opacity(
                      opacity: 0.3,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          child: Image.asset(
                            'assets/images/UNIBEN-Logo.png',
                            height: 150,
                            width: 150,
                          ),
                        ),
                      ),
                    ),
                    TextFieldNamePhone(
                      icon: const Icon(Icons.account_circle),
                      hintText: 'Enter your Full Name',
                      onChanged: (value) {
                        name = value;
                      },
                      color: kSignUpTextFieldColour,
                    ),
                    const SizedBox(height: 16.0),
                    // Course Details Input Fields
                    Column(
                      children: List.generate(courseDetails.length, (index) {
                        return Column(
                          children: [
                            TextFieldNamePhone(
                              icon: const Icon(Icons.sort_by_alpha_rounded),
                              hintText: 'Enter course code',
                              onChanged: (value) {
                                courseDetails[index]['code'] = value;
                              },
                              color: kSignUpTextFieldColour,
                            ),
                            TextFieldNamePhone(
                              icon: const Icon(Icons.sort_by_alpha_rounded),
                              hintText: 'Enter course title',
                              onChanged: (value) {
                                courseDetails[index]['title'] = value;
                              },
                              color: kSignUpTextFieldColour,
                            ),
                            if (index > 0)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    courseDetails.removeAt(index);
                                  });
                                },
                                child: const Text('Remove'),
                              ),
                          ],
                        );
                      }),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          courseDetails.add({'code': '', 'title': ''});
                        });
                      },
                      child: const Text('Add Course'),
                    ),
                    const SizedBox(height: 16.0),
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
                      height: 16.0,
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
                          try {
                            print('Creating user...');
                            final newUser =
                                await _auth.createUserWithEmailAndPassword(
                                    email: email, password: password);
                            print('User created: ${newUser.user?.uid}');
                            if (newUser != null) {
                              // Create lecturer profile in Firestore
                              print('Creating Firestore document...');
                              await _firestore
                                  .collection('lecturers')
                                  .doc(newUser.user!.uid)
                                  .set({
                                'name': name,
                              });

                              // Add courses to the courses subcollection
                              for (var course in courseDetails) {
                                await _firestore
                                    .collection('lecturers')
                                    .doc(newUser.user!.uid)
                                    .collection('courses')
                                    .add(course);
                              }

                              print('Firestore document created');
                              Navigator.pushNamed(
                                  context, LecturerProfilePage.routeName);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialogWidget(
                                    message:
                                        'Registration completed successfully. Proceed to profile',
                                    colour: Colors.indigoAccent,
                                    title: 'Registration Successful',
                                  );
                                },
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            print('FirebaseAuthException: $e');
                            String errorMessage;
                            switch (e.code) {
                              case 'email-already-in-use':
                                errorMessage =
                                    'The email address is already in use by another account.';
                                break;
                              // You can add more cases for other error codes if needed
                              default:
                                errorMessage =
                                    'An unexpected error occurred. Please try again.';
                            }
                            print('Error: $e');
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialogWidget(
                                  message: errorMessage,
                                  colour: Colors.redAccent,
                                  title: 'Registration Failed',
                                );
                              },
                            );
                          } catch (e) {
                            print('Error: $e');
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialogWidget(
                                    message: '$e',
                                    colour: Colors.redAccent,
                                    title: 'Registration Failed',
                                  );
                                });
                          } finally {
                            setState(() {
                              showSpinner = false;
                            });
                          }
                        }
                      },
                      label: 'Sign Up',
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Have an account ?",
                            style: TextStyle(color: kSignUpTextFieldColour),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, LecturerLoginScreen.routeName);
                            },
                            child: const Text(
                              'Log in Here',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
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
