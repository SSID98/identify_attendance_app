import 'package:flutter/material.dart';

class CourseSelectionDialog extends StatelessWidget {
  final List<Map<String, dynamic>> courses;

  const CourseSelectionDialog({required this.courses, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Course'),
      content: SingleChildScrollView(
        child: ListBody(
          children: courses.map((course) {
            return ListTile(
              title: Text(course['title']),
              subtitle: Text(course['code']),
              onTap: () {
                Navigator.pop(context, course);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
