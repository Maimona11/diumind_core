import '../data/mock/mock_data.dart';
import 'rag/rag_service.dart';
import 'rag/rag_models.dart';

class ContextService {
  late final RAGService _ragService;
  bool _isInitialized = false;

  ContextService() {
    _ragService = RAGService(
      chunkConfig: const ChunkConfig(
        chunkSize: 400,
        chunkOverlap: 50,
      ),
    );
  }

  /// Initialize the RAG engine with mock data
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Convert mock data into categorized documents
    final documents = _prepareDocumentsFromMockData();
    
    // Initialize RAG service
    await _ragService.initializeFromStructured(documents);
    
    _isInitialized = true;
  }

  /// Prepare structured documents from mock data
  Map<String, List<String>> _prepareDocumentsFromMockData() {
    final documents = <String, List<String>>{};

    // Student information
    documents['student'] = [
      _formatStudentInfo(),
    ];

    // Course information
    documents['courses'] = MockData.courses.map((course) {
      return _formatCourseInfo(course);
    }).toList();

    // Schedule information
    documents['schedules'] = MockData.courses.map((course) {
      return _formatScheduleInfo(course);
    }).toList();

    // Mid-term syllabus
    documents['midterms'] = MockData.courses
        .where((course) => course.midSyllabus != null)
        .map((course) {
      return _formatMidSyllabusInfo(course);
    }).toList();

    // Quizzes
    documents['quizzes'] = MockData.quizzes.map((quiz) {
      return _formatQuizInfo(quiz);
    }).toList();

    // Events
    documents['events'] = MockData.events.map((event) {
      return _formatEventInfo(event);
    }).toList();

    return documents;
  }

  String _formatStudentInfo() {
    final student = MockData.student;
    return '''Student Information:
Name: ${student.name}
ID: ${student.id}
Department: ${student.department}
Semester: ${student.semester}
Email: ${student.email}
Enrolled Courses: ${student.enrolledCourses.join(', ')}''';
  }

  String _formatCourseInfo(course) {
    return '''Course: ${course.code} - ${course.name}
Instructor: ${course.instructor}
Credits: ${course.credits}
Room: ${course.room}''';
  }

  String _formatScheduleInfo(course) {
    final scheduleStr = course.schedule.map((s) => 
      '${s.day}: ${s.startTime} - ${s.endTime} in ${s.room}'
    ).join(', ');
    
    return '''${course.code} Schedule:
Course: ${course.name}
Classes: $scheduleStr''';
  }

  String _formatMidSyllabusInfo(course) {
    if (course.midSyllabus == null) return '';
    
    final topics = course.midSyllabus!.topics.join(', ');
    return '''${course.code} Mid-term Information:
Course: ${course.name}
Exam Date: ${course.midSyllabus!.midDate}
Topics: $topics''';
  }

  String _formatQuizInfo(quiz) {
    return '''Quiz: ${quiz.courseCode} - ${quiz.title}
Date: ${quiz.date}
Topics: ${quiz.topics}
Marks: ${quiz.marks}''';
  }

  String _formatEventInfo(event) {
    return '''Event: ${event.title}
Date: ${event.date}
Location: ${event.location}
Description: ${event.description}''';
  }

  /// Retrieve relevant context using RAG
  Future<String> retrieveRelevantContext(String query) async {
    // Initialize if not already done
    if (!_isInitialized) {
      await initialize();
    }
    
    // Use RAG to retrieve relevant context
    final context = await _ragService.retrieveContext(
      query,
      topK: 3,
      minScore: 0.1,
      useHybridSearch: true,
    );
    
    // If no relevant context found, return general information
    if (context.isEmpty) {
      return _formatStudentInfo();
    }
    
    return context;
  }

  /// Get detailed search results with scores
  Future<List<SearchResult>> search(String query, {int topK = 5}) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    return await _ragService.retrieve(query, topK: topK);
  }

  // Helper methods for specific queries
  String getNextClassContext() {
    final nextClass = MockData.getNextClass();
    if (nextClass == null) {
      return 'No more classes today.';
    }
    
    final course = MockData.getCourseById(nextClass.courseId);
    if (course == null) return 'Class information not found.';
    
    return '''Next Class:
Course: ${course.code} - ${course.name}
Time: ${nextClass.startTime} - ${nextClass.endTime}
Room: ${nextClass.room}
Instructor: ${course.instructor}''';
  }

  String getTodayScheduleContext() {
    final todayClasses = MockData.getTodayClasses();
    if (todayClasses.isEmpty) {
      return 'No classes scheduled for today.';
    }
    
    StringBuffer sb = StringBuffer();
    sb.writeln('Today\'s Schedule:');
    
    for (var classSchedule in todayClasses) {
      final course = MockData.getCourseById(classSchedule.courseId);
      if (course != null) {
        sb.writeln('${classSchedule.startTime} - ${classSchedule.endTime}: ${course.code} - ${course.name} (${classSchedule.room})');
      }
    }
    
    return sb.toString();
  }

  String getQuizzesContext() {
    if (MockData.quizzes.isEmpty) {
      return 'No upcoming quizzes.';
    }
    
    StringBuffer sb = StringBuffer();
    sb.writeln('Upcoming Quizzes:');
    
    for (var quiz in MockData.quizzes) {
      sb.writeln('${quiz.courseCode} - ${quiz.title}');
      sb.writeln('Date: ${quiz.date}');
      sb.writeln('Topics: ${quiz.topics}');
      sb.writeln('Marks: ${quiz.marks}');
      sb.writeln('');
    }
    
    return sb.toString();
  }

  String getEventsContext() {
    if (MockData.events.isEmpty) {
      return 'No upcoming events.';
    }
    
    StringBuffer sb = StringBuffer();
    sb.writeln('Upcoming Campus Events:');
    
    for (var event in MockData.events) {
      sb.writeln('${event.title} - ${event.date}');
      sb.writeln('Location: ${event.location}');
      sb.writeln('Description: ${event.description}');
      sb.writeln('');
    }
    
    return sb.toString();
  }

  /// Get RAG service statistics
  Map<String, dynamic> getStats() {
    if (!_isInitialized) {
      return {'isInitialized': false};
    }
    return _ragService.getStats();
  }

  bool get isInitialized => _isInitialized;
}
