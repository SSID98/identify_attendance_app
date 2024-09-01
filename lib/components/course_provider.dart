import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourseProvider extends ChangeNotifier {
  Map<String, dynamic>? _selectedCourse;

  Map<String, dynamic>? get selectedCourse => _selectedCourse;

  void setSelectedCourse(Map<String, dynamic> course) {
    _selectedCourse = course;
    notifyListeners();
  }
}
