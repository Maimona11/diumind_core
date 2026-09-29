import '../models/student_model.dart';
import '../models/course_model.dart';
import '../models/quiz_model.dart';
import '../models/event_model.dart';

class MockData {
  static final Student student = Student(
    id: 'ST2024001',
    name: 'John Doe',
    department: 'Computer Science',
    semester: '6th',
    email: 'john.doe@diu.edu',
    enrolledCourses: ['CSE401', 'CSE402', 'CSE403', 'CSE404', 'CSE405'],
  );

  static final List<Course> courses = [
    Course(
      id: 'CSE401',
      code: 'CSE401',
      name: 'Machine Learning',
      instructor: 'Dr. Sarah Smith',
      credits: 3,
      room: 'AB-305',
      schedule: [
        ClassSchedule(
          courseId: 'CSE401',
          day: 'Sunday',
          startTime: '10:00 AM',
          endTime: '11:30 AM',
          room: 'AB-305',
        ),
        ClassSchedule(
          courseId: 'CSE401',
          day: 'Tuesday',
          startTime: '10:00 AM',
          endTime: '11:30 AM',
          room: 'AB-305',
        ),
      ],
      midSyllabus: MidSyllabus(
        topics: [
          'Introduction to Machine Learning',
          'Linear Regression',
          'Logistic Regression',
          'Neural Networks Basics',
          'Gradient Descent Optimization',
        ],
        midDate: '2026-03-25',
      ),
    ),
    Course(
      id: 'CSE402',
      code: 'CSE402',
      name: 'Database Management Systems',
      instructor: 'Prof. Michael Johnson',
      credits: 3,
      room: 'CD-201',
      schedule: [
        ClassSchedule(
          courseId: 'CSE402',
          day: 'Monday',
          startTime: '12:00 PM',
          endTime: '01:30 PM',
          room: 'CD-201',
        ),
        ClassSchedule(
          courseId: 'CSE402',
          day: 'Wednesday',
          startTime: '12:00 PM',
          endTime: '01:30 PM',
          room: 'CD-201',
        ),
      ],
      midSyllabus: MidSyllabus(
        topics: [
          'Relational Database Design',
          'SQL Queries',
          'Normalization',
          'Transactions and Concurrency',
          'Indexing',
        ],
        midDate: '2026-03-28',
      ),
    ),
    Course(
      id: 'CSE403',
      code: 'CSE403',
      name: 'Software Engineering',
      instructor: 'Dr. Emily Davis',
      credits: 3,
      room: 'EF-102',
      schedule: [
        ClassSchedule(
          courseId: 'CSE403',
          day: 'Sunday',
          startTime: '02:00 PM',
          endTime: '03:30 PM',
          room: 'EF-102',
        ),
        ClassSchedule(
          courseId: 'CSE403',
          day: 'Thursday',
          startTime: '02:00 PM',
          endTime: '03:30 PM',
          room: 'EF-102',
        ),
      ],
      midSyllabus: MidSyllabus(
        topics: [
          'SDLC Models',
          'Agile Methodology',
          'Requirements Engineering',
          'UML Diagrams',
          'Testing Strategies',
        ],
        midDate: '2026-03-30',
      ),
    ),
    Course(
      id: 'CSE404',
      code: 'CSE404',
      name: 'Computer Networks',
      instructor: 'Dr. Robert Wilson',
      credits: 3,
      room: 'GH-204',
      schedule: [
        ClassSchedule(
          courseId: 'CSE404',
          day: 'Monday',
          startTime: '08:30 AM',
          endTime: '10:00 AM',
          room: 'GH-204',
        ),
        ClassSchedule(
          courseId: 'CSE404',
          day: 'Wednesday',
          startTime: '08:30 AM',
          endTime: '10:00 AM',
          room: 'GH-204',
        ),
      ],
      midSyllabus: MidSyllabus(
        topics: [
          'OSI Model',
          'TCP/IP Protocol',
          'Network Layer',
          'Transport Layer',
          'Application Layer',
        ],
        midDate: '2026-04-02',
      ),
    ),
    Course(
      id: 'CSE405',
      code: 'CSE405',
      name: 'Artificial Intelligence',
      instructor: 'Prof. Jennifer Lee',
      credits: 3,
      room: 'AB-401',
      schedule: [
        ClassSchedule(
          courseId: 'CSE405',
          day: 'Tuesday',
          startTime: '03:30 PM',
          endTime: '05:00 PM',
          room: 'AB-401',
        ),
        ClassSchedule(
          courseId: 'CSE405',
          day: 'Thursday',
          startTime: '03:30 PM',
          endTime: '05:00 PM',
          room: 'AB-401',
        ),
      ],
      midSyllabus: MidSyllabus(
        topics: [
          'Search Algorithms',
          'Knowledge Representation',
          'Expert Systems',
          'Natural Language Processing',
          'Computer Vision Basics',
        ],
        midDate: '2026-04-05',
      ),
    ),
  ];

  static final List<Quiz> quizzes = [
    Quiz(
      id: 'Q001',
      courseId: 'CSE401',
      courseCode: 'CSE401',
      title: 'Quiz 2 - Neural Networks',
      date: '2026-03-15',
      topics: 'Neural Networks, Backpropagation, Activation Functions',
      marks: 10,
    ),
    Quiz(
      id: 'Q002',
      courseId: 'CSE402',
      courseCode: 'CSE402',
      title: 'Quiz 3 - Advanced SQL',
      date: '2026-03-18',
      topics: 'Joins, Subqueries, Views, Stored Procedures',
      marks: 10,
    ),
    Quiz(
      id: 'Q003',
      courseId: 'CSE403',
      courseCode: 'CSE403',
      title: 'Quiz 2 - Agile & Scrum',
      date: '2026-03-20',
      topics: 'Agile Principles, Scrum Framework, Sprint Planning',
      marks: 10,
    ),
    Quiz(
      id: 'Q004',
      courseId: 'CSE404',
      courseCode: 'CSE404',
      title: 'Quiz 2 - TCP/IP',
      date: '2026-03-22',
      topics: 'TCP Protocol, IP Addressing, Subnetting',
      marks: 10,
    ),
  ];

  static final List<CampusEvent> events = [
    CampusEvent(
      id: 'E001',
      title: 'Tech Fest 2026',
      date: '2026-03-20',
      location: 'Main Auditorium',
      description:
          'Annual technology festival featuring project showcases, tech talks, and competitions.',
    ),
    CampusEvent(
      id: 'E002',
      title: 'AI Workshop by Google',
      date: '2026-03-25',
      location: 'Seminar Hall AB-501',
      description:
          'Hands-on workshop on modern AI/ML tools and techniques conducted by Google engineers.',
    ),
    CampusEvent(
      id: 'E003',
      title: 'Career Fair 2026',
      date: '2026-04-01',
      location: 'University Ground',
      description:
          'Meet top tech companies for internship and job opportunities.',
    ),
    CampusEvent(
      id: 'E004',
      title: 'Hackathon',
      date: '2026-04-10',
      location: 'Computer Lab Building',
      description:
          '24-hour coding marathon. Build innovative solutions and win prizes!',
    ),
  ];

  // Helper method to get course by ID
  static Course? getCourseById(String courseId) {
    try {
      return courses.firstWhere((course) => course.id == courseId);
    } catch (e) {
      return null;
    }
  }

  // Helper method to get course by code
  static Course? getCourseByCode(String courseCode) {
    try {
      return courses.firstWhere((course) => course.code == courseCode);
    } catch (e) {
      return null;
    }
  }

  // Get today's classes
  static List<ClassSchedule> getTodayClasses() {
    final now = DateTime.now();
    final daysOfWeek = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];
    final today = daysOfWeek[now.weekday % 7];

    List<ClassSchedule> todayClasses = [];
    for (var course in courses) {
      for (var schedule in course.schedule) {
        if (schedule.day == today) {
          todayClasses.add(schedule);
        }
      }
    }
    return todayClasses;
  }

  // Get next class
  static ClassSchedule? getNextClass() {
    final todayClasses = getTodayClasses();
    if (todayClasses.isEmpty) return null;

    // Sort by start time
    todayClasses.sort((a, b) => a.startTime.compareTo(b.startTime));

    final now = DateTime.now();
    final currentTime = '${now.hour}:${now.minute.toString().padLeft(2, '0')}';

    for (var classSchedule in todayClasses) {
      // Simple time comparison (can be improved)
      if (classSchedule.startTime.compareTo(currentTime) > 0) {
        return classSchedule;
      }
    }
    return null;
  }

  // Get all knowledge as text for RAG
  static String getAllKnowledgeText() {
    StringBuffer sb = StringBuffer();

    // Student info
    sb.writeln(
        'Student Information: ${student.name} (ID: ${student.id}) is a ${student.semester} semester ${student.department} student.');
    sb.writeln('Email: ${student.email}');
    sb.writeln('');

    // Courses
    for (var course in courses) {
      sb.writeln('Course: ${course.code} - ${course.name}');
      sb.writeln('Instructor: ${course.instructor}');
      sb.writeln('Credits: ${course.credits}');
      sb.writeln('Room: ${course.room}');
      sb.writeln('Schedule:');
      for (var schedule in course.schedule) {
        sb.writeln(
            '  ${schedule.day}: ${schedule.startTime} - ${schedule.endTime} in ${schedule.room}');
      }
      if (course.midSyllabus != null) {
        sb.writeln(
            'Mid-term exam date: ${course.midSyllabus!.midDate}');
        sb.writeln('Mid-term syllabus topics:');
        for (var topic in course.midSyllabus!.topics) {
          sb.writeln('  - $topic');
        }
      }
      sb.writeln('');
    }

    // Quizzes
    sb.writeln('Upcoming Quizzes:');
    for (var quiz in quizzes) {
      sb.writeln(
          '${quiz.courseCode} - ${quiz.title} on ${quiz.date}');
      sb.writeln('Topics: ${quiz.topics}');
      sb.writeln('Marks: ${quiz.marks}');
      sb.writeln('');
    }

    // Events
    sb.writeln('Upcoming Campus Events:');
    for (var event in events) {
      sb.writeln('${event.title} on ${event.date}');
      sb.writeln('Location: ${event.location}');
      sb.writeln('Description: ${event.description}');
      sb.writeln('');
    }

    return sb.toString();
  }
}
