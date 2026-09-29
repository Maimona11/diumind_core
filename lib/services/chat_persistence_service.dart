import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/chat_session.dart';

class ChatPersistenceService {
  static const String _sessionsKey = 'chat_sessions_v1';
  static const String _activeSessionKey = 'chat_active_session_v1';

  Future<List<ChatSession>> loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_sessionsKey);

    if (raw == null || raw.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => ChatSession.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveSessions(List<ChatSession> sessions) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      sessions.map((session) => session.toJson()).toList(),
    );
    await prefs.setString(_sessionsKey, encoded);
  }

  Future<String?> loadActiveSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeSessionKey);
  }

  Future<void> saveActiveSessionId(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeSessionKey, sessionId);
  }
}
