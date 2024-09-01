import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:identify_attendance_app/screens/sessionoptionspage.dart';
import 'package:identify_attendance_app/screens/view_profile.dart';
import 'package:provider/provider.dart';

import '../components/course_provider.dart';
import '../components/courseselectiondialog.dart';
import '../components/range_selection_dialog.dart';
import '../components/rounded_button.dart';
import '../components/session_provider.dart';
import '../components/side_bar_list_widget.dart';
import 'lecturer_login_screen.dart';

class LecturerProfilePage extends StatelessWidget {
  static const String routeName = 'lecturer_profile_page';

  const LecturerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    String sessionCode = Provider.of<SessionProvider>(context).sessionCode;
    final User? user = FirebaseAuth.instance.currentUser;
    final String lecturerId = user?.uid ?? '';
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(builder: (context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.indigoAccent,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 0.0),
                      blurRadius: 1.0,
                      spreadRadius: 0.1,
                    ),
                  ],
                ),
                child: const Icon(Icons.menu),
              ),
            );
          }),
        ),
        toolbarHeight: 70,
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Lecturer Profile',
            style: TextStyle(
              fontSize: 25.0,
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
              decoration: const BoxDecoration(color: Colors.indigoAccent),
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
                  const Text(
                    'IDentify',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
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
            const SizedBox(height: 10.0),
            SideBarListWidget(
              icon: Icons.library_books_sharp,
              text1: 'Create Session',
              text2: 'Proceed to Create Session',
              onPress: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 10.0),
            SideBarListWidget(
              icon: Icons.power_settings_new,
              text1: 'Log Out',
              text2: 'Log out of your Profile',
              onPress: () {
                Navigator.pushNamed(context, LecturerLoginScreen.routeName);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundedButton(
              onPress: () async {
                if (lecturerId.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No lecturer ID found')),
                  );
                  return;
                }

                // Fetch lecturer name
                String? lecturerName = await fetchLecturerData(lecturerId);
                if (lecturerName == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No lecturer name found')),
                  );
                  return;
                }

                // Fetch courses and show selection dialog
                List<Map<String, dynamic>> courses =
                    await fetchCourses(lecturerId);

                if (courses.isNotEmpty) {
                  // Show course selection dialog
                  Map<String, dynamic>? selectedCourse = await showDialog(
                    context: context,
                    builder: (context) {
                      return CourseSelectionDialog(courses: courses);
                    },
                  );

                  if (selectedCourse != null) {
                    // Set the selected course in the provider
                    Provider.of<CourseProvider>(context, listen: false)
                        .setSelectedCourse(selectedCourse);

                    // Show range selection dialog
                    Map<String, dynamic>? selectedRange = await showDialog(
                      context: context,
                      builder: (context) {
                        return RangeSelectionDialog();
                      },
                    );

                    if (selectedRange != null) {
                      // Generate session code
                      sessionCode = _generateSessionCode();

                      // Set session code in provider
                      Provider.of<SessionProvider>(context, listen: false)
                          .setSessionCode(sessionCode);

                      // Create session with selected course and range
                      await createSession(
                        lecturerId,
                        sessionCode,
                        selectedCourse,
                        selectedRange,
                      );

                      // Show session code dialog
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              'Session Created',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 35.0,
                              ),
                            ),
                            content: Text(
                              'Session Code: $sessionCode',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25.0),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SessionOptionsPage(
                                      sessionId: sessionCode,
                                      lecturerName: lecturerName,
                                      selectedCourse: selectedCourse,
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'OK',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Failed to select location range')),
                      );
                    }
                  }
                } else {
                  // Show error message if no courses found
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('No courses found for this lecturer')),
                  );
                }
              },
              colour: Colors.indigo,
              label: 'Create Session',
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> fetchLecturerData(String lecturerId) async {
    try {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('lecturers')
          .doc(lecturerId)
          .get();

      return userData['name'];
    } catch (e) {
      print('Error fetching lecturer data: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchCourses(String lecturerId) async {
    try {
      print('Fetching courses for lecturer ID: $lecturerId');
      final snapshot = await FirebaseFirestore.instance
          .collection('lecturers')
          .doc(lecturerId)
          .collection('courses')
          .get();

      if (snapshot.docs.isEmpty) {
        print('No courses found for lecturer ID: $lecturerId');
      } else {
        print(
            'Courses fetched: ${snapshot.docs.map((doc) => doc.data()).toList()}');
      }

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching courses: $e');
      return [];
    }
  }

  Future<void> createSession(
    String lecturerId,
    String sessionCode,
    Map<String, dynamic> course,
    Map<String, dynamic> range,
  ) async {
    try {
      CollectionReference attendanceCollection = FirebaseFirestore.instance
          .collection('lecturers')
          .doc(lecturerId)
          .collection('sessions');

      await attendanceCollection.add({
        'sessionCode': sessionCode,
        'createdAt': FieldValue.serverTimestamp(),
        'courseCode': course['code'],
        'courseTitle': course['title'],
        'lecturerId': lecturerId,
        'latitude': range['latitude'],
        'longitude': range['longitude'],
        'radius': range['radius'],
      });
    } catch (e) {
      print('Error creating session: $e');
    }
  }

  // Helper function to generate a 6-digit session code
  String _generateSessionCode() {
    // Generate a random 6-digit number
    return (100000 + Random().nextInt(900000)).toString();
  }
}
