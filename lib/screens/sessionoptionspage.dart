import 'package:flutter/material.dart';
import 'package:identify_attendance_app/components/side_bar_list_widget.dart';
import 'package:identify_attendance_app/screens/attendance_record_page.dart';
import 'package:provider/provider.dart';

import '../components/session_provider.dart';
import 'lecturer_qr_code_screen.dart';

class SessionOptionsPage extends StatelessWidget {
  static const String routeName = 'session_options_page';

  final String sessionId;
  final String lecturerName;
  final Map<String, dynamic> selectedCourse;

  SessionOptionsPage({
    required this.sessionId,
    required this.lecturerName,
    required this.selectedCourse,
  });

  @override
  Widget build(BuildContext context) {
    // Fetch sessionCode from the provider
    String sessionCode = Provider.of<SessionProvider>(context).sessionCode;

    return Scaffold(
      appBar: AppBar(
        title: Text('Session Options'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SideBarListWidget(
              icon: Icons.qr_code,
              text1: 'Generate QR Code',
              text2: '',
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LecturerQrCodeScreen(
                      sessionId: sessionId,
                      lecturerName: lecturerName,
                      selectedCourse: selectedCourse,
                    ),
                  ),
                );
              },
            ),
            SideBarListWidget(
              icon: Icons.note_alt_outlined,
              text1: 'View Attendance Record',
              text2: '',
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AttendanceRecordPage(
                      sessionId: sessionCode,
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
