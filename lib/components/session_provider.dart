import 'package:flutter/material.dart';

class SessionProvider with ChangeNotifier {
  String _sessionCode = '';

  String get sessionCode => _sessionCode;

  void setSessionCode(String code) {
    _sessionCode = code;
    notifyListeners();
  }
}
