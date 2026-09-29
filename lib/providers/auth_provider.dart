import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/mock/mock_linked_data.dart';
import '../data/models/linked_student_data.dart';

class AuthProvider with ChangeNotifier {
  static const String _sessionKey = 'auth_email';
  static const String _allowedEmail = 'maimona242-15-324@diu.edu.bd';
  static const String _allowedPassword = 'maimona324';

  bool _isAuthenticated = false;
  bool _isRestoring = true;
  LinkedStudentData? _linkedData;

  AuthProvider() {
    _restoreSession();
  }

  bool get isAuthenticated => _isAuthenticated;
  bool get isRestoring => _isRestoring;
  LinkedStudentData? get linkedData => _linkedData;

  Future<void> _restoreSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString(_sessionKey);
      if (email != null && email.toLowerCase() == _allowedEmail) {
        _isAuthenticated = true;
        _linkedData = maimonaLinkedData;
      }
    } finally {
      _isRestoring = false;
      notifyListeners();
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final normalizedPassword = password.trim();

    if (normalizedEmail == _allowedEmail &&
        normalizedPassword == _allowedPassword) {
      _isAuthenticated = true;
      _linkedData = maimonaLinkedData;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_sessionKey, normalizedEmail);

      notifyListeners();
      return true;
    }

    return false;
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _linkedData = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);

    notifyListeners();
  }
}
