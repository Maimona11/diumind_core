class LinkedRoutineItem {
  final String day;
  final String startTime;
  final String endTime;
  final String courseCode;
  final String courseTitle;
  final String section;
  final String teacherInitial;
  final String room;

  const LinkedRoutineItem({
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.courseCode,
    required this.courseTitle,
    required this.section,
    required this.teacherInitial,
    required this.room,
  });
}

class LinkedUpcomingEvent {
  final String title;
  final String date;
  final String during;
  final String syllabus;

  const LinkedUpcomingEvent({
    required this.title,
    required this.date,
    required this.during,
    this.syllabus = '',
  });
}

class LinkedStudentData {
  final String email;
  final String name;
  final String phone;
  final String sex;
  final String bloodGroup;
  final String batch;
  final String shift;
  final String campus;
  final String program;
  final String department;
  final String faculty;
  final String issueDate;
  final String expireDate;
  final String section;
  final double totalPayable;
  final double totalPaid;
  final double totalDue;
  final double totalOther;
  final List<double> semesterWiseResult;
  final String semesterWaiverSemester;
  final double semesterWaiverRate;
  final String semesterWaiverCategory;
  final String semesterWaiverSubCategory;
  final bool semesterWaiverIsFullWaiver;
  final String fixedWaiverCategory;
  final double fixedWaiverRate;
  final String fixedWaiverType;
  final String fixedWaiverEffectiveSemester;
  final double fixedWaiverMinimumSgpa;
  final double fixedWaiverMinimumCredit;
  final String fixedWaiverReferenceRegistration;
  final String fixedWaiverReferenceId;
  final bool fixedWaiverFullWaiver;
  final String fixedWaiverRemarks;
  final List<LinkedUpcomingEvent> upcomingEvents;
  final List<LinkedRoutineItem> routine;
  final Map<String, List<String>> questionBankDepartmentCourses;

  const LinkedStudentData({
    required this.email,
    required this.name,
    required this.phone,
    required this.sex,
    required this.bloodGroup,
    required this.batch,
    required this.shift,
    required this.campus,
    required this.program,
    required this.department,
    required this.faculty,
    required this.issueDate,
    required this.expireDate,
    required this.section,
    required this.totalPayable,
    required this.totalPaid,
    required this.totalDue,
    required this.totalOther,
    required this.semesterWiseResult,
    required this.semesterWaiverSemester,
    required this.semesterWaiverRate,
    required this.semesterWaiverCategory,
    required this.semesterWaiverSubCategory,
    required this.semesterWaiverIsFullWaiver,
    required this.fixedWaiverCategory,
    required this.fixedWaiverRate,
    required this.fixedWaiverType,
    required this.fixedWaiverEffectiveSemester,
    required this.fixedWaiverMinimumSgpa,
    required this.fixedWaiverMinimumCredit,
    required this.fixedWaiverReferenceRegistration,
    required this.fixedWaiverReferenceId,
    required this.fixedWaiverFullWaiver,
    required this.fixedWaiverRemarks,
    required this.upcomingEvents,
    required this.routine,
    required this.questionBankDepartmentCourses,
  });
}
