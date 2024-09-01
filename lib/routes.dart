import 'package:flutter/cupertino.dart';
import 'package:identify_attendance_app/components/face_biometrics.dart';
import 'package:identify_attendance_app/screens/attendance_record_page.dart';
import 'package:identify_attendance_app/screens/lecturer_login_screen.dart';
import 'package:identify_attendance_app/screens/lecturer_profile_screen.dart';
import 'package:identify_attendance_app/screens/lecturer_qr_code_screen.dart';
import 'package:identify_attendance_app/screens/lecturer_registration_screen.dart';
import 'package:identify_attendance_app/screens/lecturer_screen.dart';
import 'package:identify_attendance_app/screens/qr_scanner_page.dart';
import 'package:identify_attendance_app/screens/sessionoptionspage.dart';
import 'package:identify_attendance_app/screens/student_login_page.dart';
import 'package:identify_attendance_app/screens/student_profile_page.dart';
import 'package:identify_attendance_app/screens/student_registration_screen.dart';
import 'package:identify_attendance_app/screens/student_screen.dart';
import 'package:identify_attendance_app/screens/view_profile.dart';
import 'package:identify_attendance_app/screens/welcome_screen.dart';

Map<String, WidgetBuilder> routes = {
  StudentScreen.routeName: (context) => StudentScreen(),
  StudentRegistrationScreen.routeName: (context) => StudentRegistrationScreen(),
  StudentLoginScreen.routeName: (context) => StudentLoginScreen(),
  WelcomeScreen.routeName: (context) => WelcomeScreen(),
  LecturerScreen.routeName: (context) => LecturerScreen(),
  LecturerLoginScreen.routeName: (context) => LecturerLoginScreen(),
  LecturerRegistrationScreen.routeName: (context) =>
      LecturerRegistrationScreen(),
  LecturerQrCodeScreen.routeName: (context) => LecturerQrCodeScreen(
        sessionId: '',
        lecturerName: '',
        selectedCourse: {},
      ),
  QRScannerPage.routeName: (context) => QRScannerPage(),
  QRScanner.routeName: (context) => QRScanner(
        sessionCode: '',
      ),
  LecturerProfilePage.routeName: (context) => LecturerProfilePage(),
  StudentProfilePage.routeName: (context) => StudentProfilePage(),
  AttendanceRecordPage.routeName: (context) => AttendanceRecordPage(
        sessionId: '',
      ),
  ViewProfileScreen.routeName: (context) => ViewProfileScreen(),
  SessionOptionsPage.routeName: (context) =>
      SessionOptionsPage(sessionId: '', lecturerName: '', selectedCourse: {}),
  FaceBiometricsWidget.routeName: (context) => FaceBiometricsWidget(),
};
