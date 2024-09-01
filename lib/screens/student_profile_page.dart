import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:identify_attendance_app/components/face_biometrics.dart';
import 'package:identify_attendance_app/screens/qr_scanner_page.dart';
import 'package:identify_attendance_app/screens/student_login_page.dart';
import 'package:identify_attendance_app/screens/view_profile.dart';
import 'package:provider/provider.dart';

import '../components/rounded_button.dart';
import '../components/session_provider.dart';
import '../components/side_bar_list_widget.dart';

class StudentProfilePage extends StatelessWidget {
  static const String routeName = 'student_profile_page';

  const StudentProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController sessionCodeController = TextEditingController();
    String sessionCode = Provider.of<SessionProvider>(context).sessionCode;

    void _showAttendanceOptionsDialog(
        BuildContext context, String sessionCode) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select Attendance Method'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.face),
                  title: Text('Face Biometrics'),
                  onTap: () {
                    Navigator.pushNamed(
                        context, FaceBiometricsWidget.routeName);
                    print('Face Biometrics selected');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.qr_code),
                  title: Text('QR Code'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QRScanner(sessionCode: sessionCode),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                Scaffold.of(context)
                    .openDrawer(); // Open drawer on menu icon tap
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.indigoAccent,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: const Offset(
                        0.0,
                        0.0,
                      ),
                      blurRadius: 1.0,
                      spreadRadius: 0.1,
                    ), //BoxShadow
                  ],
                ),
                child: Icon(
                  Icons.menu,
                ),
              ),
            ),
          ),
        ),
        toolbarHeight: 70,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Welcome Student',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ),
        titleSpacing: 4.0,
        shadowColor: Colors.white70,
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigoAccent,
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image.asset(
                      'assets/images/ID.png',
                      width: 70.0,
                      height: 70.0,
                    ),
                  ),
                  Text(
                    'IDentify',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Smart Attendance System',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            SideBarListWidget(
              icon: Icons.person,
              text1: 'My Profile',
              text2: 'View your Profile',
              onPress: () {
                Navigator.pushNamed(context, ViewProfileScreen.routeName);
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            SideBarListWidget(
              icon: Icons.library_books_sharp,
              text1: 'Take Attendance',
              text2: 'Proceed to Take Attendance',
              onPress: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            SideBarListWidget(
              icon: Icons.power_settings_new,
              text1: 'Log Out',
              text2: 'Log out of your Profile',
              onPress: () {
                // Navigate to another screen or perform an action
                FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, StudentLoginScreen.routeName);
              },
            ),

            // Add more ListTile widgets for additional options
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 50.0, right: 50.0, bottom: 20.0),
            child: TextFormField(
              controller: sessionCodeController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Please input session code',
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.indigoAccent),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.indigoAccent, width: 2.0),
                ),
              ),
            ),
          ),
          RoundedButton(
            onPress: () {
              sessionCode = sessionCodeController.text.trim();
              if (sessionCode.isNotEmpty) {
                _showAttendanceOptionsDialog(context, sessionCode);
              } else {
                // Session code is empty
                print('Session code is empty');
              }
            },
            colour: Colors.indigo,
            label: 'Take Attendance',
          ),
        ],
      ),
    );
  }
}
