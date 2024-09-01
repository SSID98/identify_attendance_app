import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../components/session_provider.dart';

class AttendanceRecordPage extends StatefulWidget {
  static const String routeName = 'attendance_record_page';

  final String sessionId;

  AttendanceRecordPage({required this.sessionId});

  @override
  State<AttendanceRecordPage> createState() => _AttendanceRecordPageState();
}

class _AttendanceRecordPageState extends State<AttendanceRecordPage> {
  List<Map<String, dynamic>> attendanceData = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String sessionCode = Provider.of<SessionProvider>(context).sessionCode;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.indigoAccent,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  offset: const Offset(1.0, 1.0),
                  blurRadius: 5.0,
                  spreadRadius: 0.10,
                ),
                BoxShadow(
                  color: Colors.indigoAccent,
                  offset: const Offset(2.0, 2.0),
                  blurRadius: 10.0,
                  spreadRadius: 5.0,
                ),
              ],
            ),
            child: Icon(Icons.menu),
          ),
        ),
        toolbarHeight: 70,
        title: Text(
          'Student Attendance Record',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        titleSpacing: 4.0,
        shadowColor: Colors.white70,
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('sessions')
              .doc(sessionCode)
              .collection('attendance')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            List<DocumentSnapshot> documents = snapshot.data!.docs;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 90.0,
                columns: [
                  DataColumn(label: Text('SN'), numeric: true),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('MatNo')),
                  DataColumn(label: Text('Course Code')),
                  DataColumn(label: Text('Course Title')),
                ],
                rows: documents.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  return DataRow(
                    cells: [
                      DataCell(Text(data['sn'].toString())),
                      DataCell(Text(data['name'] ?? '')),
                      DataCell(Text(data['matNo'] ?? '')),
                      DataCell(Text(data['courseCode'] ?? '')),
                      DataCell(Text(data['courseTitle'] ?? '')),
                    ],
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          List<Map<String, dynamic>> attendanceData =
              await _fetchAttendanceDataFromFirestore(sessionCode);
          _downloadAttendanceAsCsv(attendanceData);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Attendance CSV file downloaded successfully'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        child: Icon(
          Icons.download,
          color: Colors.indigo,
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchAttendanceDataFromFirestore(
      String sessionCode) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('sessions')
          .doc(sessionCode)
          .collection('attendance')
          .orderBy('sn')
          .get();
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        attendanceData = querySnapshot.docs.map((doc) {
          return doc.data() as Map<String, dynamic>;
        }).toList();
      });
      return attendanceData;
    } catch (e) {
      print('Error fetching attendance data: $e');
      return [];
    }
  }

  Future<void> _downloadAttendanceAsCsv(
      List<Map<String, dynamic>> attendanceData) async {
    List<List<dynamic>> rows = [
      ['SN', 'Name', 'MatNo', 'Course Code', 'Course Title', 'Downloaded At']
    ];

    DateTime now = DateTime.now();
    String formattedDate =
        '${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}';

    attendanceData.forEach((data) {
      rows.add([
        data['sn'],
        data['name'],
        data['matNo'],
        data['courseCode'],
        data['courseTitle'],
        formattedDate,
      ]);
    });

    String csv = const ListToCsvConverter().convert(rows);

    final directory = await getExternalStorageDirectory();
    final filePath = '${directory!.path}/attendance_record.csv';
    File file = File(filePath);
    await file.writeAsString(csv);
  }
}
