import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../components/course_provider.dart';

class QRScannerPage extends StatelessWidget {
  static const String routeName = 'qr_scanner_page';

  const QRScannerPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(
                context, QRScanner.routeName); // Navigate to QR scanner page
          },
          child: Text('Scan QR Code'),
        ),
      ),
    );
  }
}

class QRScanner extends StatefulWidget {
  static const String routeName = 'qr_scanner';
  final String sessionCode;

  QRScanner({
    super.key,
    required this.sessionCode,
  });

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool flashOn = false;
  bool isFlashAvailable = false;
  bool cameraRear = true;
  String _attendanceMessage = '';
  final User? user = FirebaseAuth.instance.currentUser;
  late final String studentId = user?.uid ?? '';

  @override
  void initState() {
    super.initState();
    initFlashlight();
  }

  void initFlashlight() async {
    if (controller != null) {
      bool? available = await controller!.getFlashStatus();
      setState(() {
        isFlashAvailable = available!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Take Attendance',
          style: GoogleFonts.openSans(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: _buildQrView(context),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Center(
                  child: Text(
                    _attendanceMessage,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: _attendanceMessage.contains('successfully')
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.blueAccent),
                        child: IconButton(
                          iconSize: 30.0,
                          color: Colors.white,
                          icon:
                              Icon(flashOn ? Icons.flash_on : Icons.flash_off),
                          onPressed: () async {
                            if (controller != null && isFlashAvailable) {
                              await controller?.toggleFlash();
                            }
                            setState(() {
                              flashOn = !flashOn;
                            });
                          },
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.blueAccent),
                        child: IconButton(
                          iconSize: 30.0,
                          color: Colors.white,
                          icon: Icon(cameraRear
                              ? Icons.camera_front
                              : Icons.camera_rear),
                          onPressed: () async {
                            if (controller != null) {
                              await controller!.flipCamera();
                            }
                            setState(() {
                              cameraRear = !cameraRear;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.blue,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      _handleQRCodeResult(scanData.code.toString());
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Permission')),
      );
    }
  }

  void _handleQRCodeResult(String qrCodeData) async {
    List<String> dataParts = qrCodeData.split('\n');
    if (dataParts.length >= 2) {
      String lecturerName = dataParts[0].length > 'Lecturer: '.length
          ? dataParts[0].substring('Lecturer: '.length)
          : '';
      String coursesString = dataParts[1].length > 'Courses: '.length
          ? dataParts[1].substring('Courses: '.length)
          : '';
      List<String> coursesList =
          coursesString.split(', '); // Split courses into a list

      // Construct a map of course codes and titles
      Map<String, String> coursesMap = {};
      for (String course in coursesList) {
        List<String> courseParts = course.split(': ');
        if (courseParts.length == 2) {
          coursesMap[courseParts[0].trim()] = courseParts[1].trim();
        }
      }

      // Now you can use lecturerName and coursesMap to take attendance or perform other operations
      await takeAttendance(widget.sessionCode, lecturerName);
    } else {
      setState(() {
        _attendanceMessage = 'Not within the required location.';
      });
    }
  }

  Future<Map<String, String>> _fetchStudentInfo() async {
    try {
      if (studentId.isNotEmpty) {
        DocumentSnapshot studentSnapshot = await FirebaseFirestore.instance
            .collection('student')
            .doc(studentId)
            .get();

        if (studentSnapshot.exists) {
          // Extract student information from the document
          String studentName = studentSnapshot['name'];
          String studentMatNumber = studentSnapshot['matnumber'];
          return {
            'studentName': studentName,
            'studentMatNumber': studentMatNumber
          };
        } else {
          print('Student document does not exist');
          return {'studentName': '', 'studentMatNumber': ''};
        }
      } else {
        print('No student ID found');
        return {'studentName': '', 'studentMatNumber': ''};
      }
    } catch (e) {
      print('Error fetching student information: $e');
      return {'studentName': '', 'studentMatNumber': ''};
    }
  }

  Future<void> takeAttendance(String sessionCode, String lecturerName) async {
    try {
      final QuerySnapshot sessionSnapshot = await FirebaseFirestore.instance
          .collectionGroup('sessions')
          .where('sessionCode', isEqualTo: sessionCode)
          .get();

      if (sessionSnapshot.docs.isEmpty) {
        // Session not found
        print('Session not found');
        setState(() {
          _attendanceMessage = 'Session not found';
        });
      } else {
        // Session found
        final DocumentSnapshot sessionDoc = sessionSnapshot.docs.first;
        final String lecturerId = sessionDoc['lecturerId'];
        final double sessionLatitude = sessionDoc['latitude'];
        final double sessionLongitude = sessionDoc['longitude'];
        final double sessionRadius = sessionDoc['radius'];

        // Get student information
        Map<String, dynamic> studentInfo = await _fetchStudentInfo();
        String studentName = studentInfo['studentName'];
        String studentMatNumber = studentInfo['studentMatNumber'];

        // Log the session information
        print('Session Information:');
        print('Lecturer ID: $lecturerId');
        print(
            'Latitude: $sessionLatitude, Longitude: $sessionLongitude, Radius: $sessionRadius');

        // Fetch the actual location of the student
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        double studentLatitude = position.latitude;
        double studentLongitude = position.longitude;

        // Log the student position
        print('Student Position: Lat=$studentLatitude, Lon=$studentLongitude');
        print(
            'Session Position: Lat=$sessionLatitude, Lon=$sessionLongitude, Range=$sessionRadius');

        // Manually calculate distance for verification
        double distance = Geolocator.distanceBetween(
          sessionLatitude,
          sessionLongitude,
          studentLatitude,
          studentLongitude,
        );
        // Log the distance
        print('Calculated distance to session: $distance');

        if (distance <= sessionRadius) {
          // Within range, check if attendance is already recorded
          CollectionReference attendanceCollection = FirebaseFirestore.instance
              .collection('lecturers')
              .doc(lecturerId)
              .collection('sessions')
              .doc(sessionDoc.id)
              .collection('attendance');

          // Check if the student has already taken attendance
          final QuerySnapshot existingAttendance = await attendanceCollection
              .where('studentId', isEqualTo: studentId)
              .get();

          if (existingAttendance.docs.isNotEmpty) {
            // Attendance already recorded
            print('Attendance already recorded for this student');
            setState(() {
              _attendanceMessage =
                  'You have already taken attendance for this session';
            });
            _showDialog('Attendance Status',
                'You have already taken attendance for this session.');
          } else {
            // Attendance not recorded, proceed to add
            await attendanceCollection.add({
              'studentId': studentId,
              'studentName': studentName, // Add student name
              'studentMatNumber': studentMatNumber, // Add student mat number
              'course': Provider.of<CourseProvider>(context, listen: false)
                  .selectedCourse,
              'timestamp': FieldValue.serverTimestamp(),
            });

            print('Attendance recorded');
            setState(() {
              _attendanceMessage = 'Attendance recorded successfully';
            });
            _showDialog(
                'Attendance Status', 'Attendance recorded successfully.');
          }
        } else {
          // Not within range
          print('You are not within the required range to take attendance');
          setState(() {
            _attendanceMessage =
                'You are not within the required range to take attendance';
          });
          _showDialog('Attendance Status',
              'You are not within the required range to take attendance.');
        }
      }
    } catch (e) {
      print('Error taking attendance: $e');
      setState(() {
        _attendanceMessage = 'Error taking attendance';
      });
      _showDialog('Error', 'Error taking attendance.');
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
