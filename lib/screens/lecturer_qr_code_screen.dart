import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class LecturerQrCodeScreen extends StatefulWidget {
  static const String routeName = 'lecturer_qr_code_screen';
  final String sessionId;
  final String lecturerName;
  final Map<String, dynamic> selectedCourse;

  LecturerQrCodeScreen({
    super.key,
    required this.sessionId,
    required this.lecturerName,
    required this.selectedCourse,
  });

  @override
  _LecturerQrCodeScreenState createState() => _LecturerQrCodeScreenState();
}

class _LecturerQrCodeScreenState extends State<LecturerQrCodeScreen> {
  bool _isLoading = true;
  late String qrData;

  @override
  void initState() {
    super.initState();
    _loadQrData();
  }

  void _loadQrData() async {
    // Simulate a delay to show loading spinner
    await Future.delayed(Duration(seconds: 1));
    qrData = _generateQrData();
    setState(() {
      _isLoading = false;
    });
  }

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
        backgroundColor: Colors.blueAccent.withOpacity(1),
        foregroundColor: Colors.white70,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 70.0, left: 30, right: 30.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.blueAccent),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Lecturer QR Slip',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white54,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                if (_isLoading)
                  Center(
                    child: CircularProgressIndicator(),
                  )
                else
                  Center(
                    child: QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    height: 110.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.blueAccent),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Text(
                        'Students are expected to scan this QR Code ticket to take attendance ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _generateQrData() {
    if (widget.lecturerName.isEmpty || widget.selectedCourse.isEmpty) {
      return 'Loading...';
    }

    String coursesString = widget.selectedCourse.entries.map<String>((entry) {
      var courseDetails = entry.value;
      if (courseDetails is Map<String, dynamic>) {
        String courseCode = courseDetails['courseCode'] ?? 'N/A';
        String courseTitle = courseDetails['courseTitle'] ?? 'N/A';
        return '$courseCode: $courseTitle';
      } else {
        return 'Invalid course data';
      }
    }).join('\n');

    return 'Lecturer: ${widget.lecturerName}\nCourses:\n$coursesString';
  }
}
