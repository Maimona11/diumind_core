import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';
import '../data/models/chat_message.dart';
import '../data/models/chat_session.dart';
import '../services/groq_service.dart';
import '../services/context_service.dart';
import '../services/chat_persistence_service.dart';

class ChatProvider with ChangeNotifier {
  final List<ChatSession> _sessions = [];
  final GroqService _groqService;
  final ContextService _contextService;
  final ChatPersistenceService _persistenceService;
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _activeSessionId;
  String? _error;
  final Uuid _uuid = const Uuid();

  ChatProvider({
    required GroqService groqService,
    required ContextService contextService,
    ChatPersistenceService? persistenceService,
  })  : _groqService = groqService,
        _contextService = contextService,
        _persistenceService = persistenceService ?? ChatPersistenceService() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadPersistedSessions();

    if (_sessions.isEmpty) {
      _createNewSessionInternal(addWelcomeMessage: false);
      _addMessage(
        text:
            "Hello! I'm your DIU student assistant 👋\n\nI'm initializing my knowledge base...",
        isUser: false,
      );
    }

    try {
      await _contextService.initialize();
      _isInitialized = true;

      final current = _currentSession;
      if (current != null && current.messages.length == 1) {
        _replaceCurrentMessages([
          ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text:
                "Hello! I'm your DIU student assistant 👋\n\nI can help you with:\n• Your course schedule\n• Next class information\n• Mid-term syllabus\n• Upcoming quizzes\n• Campus events\n\nWhat would you like to know?",
            isUser: false,
            timestamp: DateTime.now(),
          ),
        ]);
      }
    } catch (e) {
      _error = e.toString();
      _addMessage(
        text: "Sorry, I encountered an error initializing: $e",
        isUser: false,
      );
    }

    await _persistSessions();
    notifyListeners();
  }

  Future<void> _loadPersistedSessions() async {
    _sessions
      ..clear()
      ..addAll(await _persistenceService.loadSessions());

    final persistedActiveId = await _persistenceService.loadActiveSessionId();
    if (persistedActiveId != null &&
        _sessions.any((session) => session.id == persistedActiveId)) {
      _activeSessionId = persistedActiveId;
    } else if (_sessions.isNotEmpty) {
      _activeSessionId = _sessions.first.id;
    }
  }

  Future<void> _persistSessions() async {
    await _persistenceService.saveSessions(_sessions);
    if (_activeSessionId != null) {
      await _persistenceService.saveActiveSessionId(_activeSessionId!);
    }
  }

  ChatSession? get _currentSession {
    if (_activeSessionId == null) return null;
    try {
      return _sessions.firstWhere((session) => session.id == _activeSessionId);
    } catch (_) {
      return null;
    }
  }

  int get _currentSessionIndex {
    if (_activeSessionId == null) return -1;
    return _sessions.indexWhere((session) => session.id == _activeSessionId);
  }

  List<ChatSession> get sessions => List.unmodifiable(_sessions);
  String? get activeSessionId => _activeSessionId;
  List<ChatMessage> get messages => _currentSession?.messages ?? [];
  String get currentSessionTitle => _currentSession?.title ?? 'Session';
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  String? get error => _error;

  void _addMessage({required String text, required bool isUser}) {
    final index = _currentSessionIndex;
    if (index == -1) return;

    final updatedMessages = [
      ..._sessions[index].messages,
      ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        isUser: isUser,
        timestamp: DateTime.now(),
      ),
    ];

    _sessions[index] = _sessions[index].copyWith(
      messages: updatedMessages,
      updatedAt: DateTime.now(),
      title: _deriveTitle(updatedMessages),
    );

    _persistSessions();
    notifyListeners();
  }

  void _replaceCurrentMessages(List<ChatMessage> messages) {
    final index = _currentSessionIndex;
    if (index == -1) return;
    _sessions[index] = _sessions[index].copyWith(
      messages: messages,
      updatedAt: DateTime.now(),
      title: _deriveTitle(messages),
    );
  }

  String _deriveTitle(List<ChatMessage> messages) {
    final firstUserMessage = messages.where((message) => message.isUser).firstOrNull;
    if (firstUserMessage == null) {
      return 'New Session';
    }
    final raw = firstUserMessage.text.trim().replaceAll('\n', ' ');
    if (raw.isEmpty) return 'New Session';
    return raw.length > 28 ? '${raw.substring(0, 28)}...' : raw;
  }

  Future<void> createNewSession() async {
    _createNewSessionInternal(addWelcomeMessage: _isInitialized);
    await _persistSessions();
    notifyListeners();
  }

  void _createNewSessionInternal({required bool addWelcomeMessage}) {
    final now = DateTime.now();
    final session = ChatSession(
      id: _uuid.v4(),
      title: 'New Session',
      createdAt: now,
      updatedAt: now,
      messages: [],
    );
    _sessions.insert(0, session);
    _activeSessionId = session.id;

    if (addWelcomeMessage) {
      _addMessage(
        text:
            "Hello! I'm your DIU student assistant 👋\n\nWhat would you like to know?",
        isUser: false,
      );
    }
  }

  Future<void> switchSession(String sessionId) async {
    if (_activeSessionId == sessionId) return;
    if (!_sessions.any((session) => session.id == sessionId)) return;

    _activeSessionId = sessionId;
    await _persistSessions();
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Check if initialized
    if (!_isInitialized) {
      _addMessage(
        text: "Please wait, I'm still initializing...",
        isUser: false,
      );
      return;
    }

    // Clear any previous errors
    _error = null;

    // Add user message
    _addMessage(text: text, isUser: true);

    // Set loading state
    _isLoading = true;
    notifyListeners();

    try {
      // Retrieve relevant context using RAG
      final context = await _contextService.retrieveRelevantContext(text);

      // Generate response using Groq
      final response = await _groqService.chat(text, context);

      // Add bot response
      _addMessage(text: response, isUser: false);
    } catch (e) {
      _error = e.toString();
      _addMessage(
        text: "Sorry, I encountered an error: ${e.toString()}\n\nPlease try again.",
        isUser: false,
      );
    } finally {
      _isLoading = false;
      await _persistSessions();
      notifyListeners();
    }
  }

  Future<void> clearMessages() async {
    final index = _currentSessionIndex;
    if (index == -1) return;

    _sessions[index] = _sessions[index].copyWith(
      messages: [
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: "Hello! I'm your DIU student assistant 👋\n\nWhat would you like to know?",
          isUser: false,
          timestamp: DateTime.now(),
        ),
      ],
      updatedAt: DateTime.now(),
      title: 'New Session',
    );

    _error = null;
    await _persistSessions();
    notifyListeners();
  }

  /// Get RAG statistics
  Map<String, dynamic> getRAGStats() {
    return _contextService.getStats();
  }
}
