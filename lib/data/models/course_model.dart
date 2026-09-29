import 'package:json_annotation/json_annotation.dart';

part 'course_model.g.dart';

@JsonSerializable()
class Course {
  final String id;
  final String code;
  final String name;
  final String instructor;
  final int credits;
  final String room;
  final List<ClassSchedule> schedule;
  final MidSyllabus? midSyllabus;

  Course({
    required this.id,
    required this.code,
    required this.name,
    required this.instructor,
    required this.credits,
    required this.room,
    required this.schedule,
    this.midSyllabus,
  });

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
  Map<String, dynamic> toJson() => _$CourseToJson(this);
}

@JsonSerializable()
class ClassSchedule {
  final String courseId;
  final String day;
  final String startTime;
  final String endTime;
  final String room;

  ClassSchedule({
    required this.courseId,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.room,
  });

  factory ClassSchedule.fromJson(Map<String, dynamic> json) =>
      _$ClassScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$ClassScheduleToJson(this);
}

@JsonSerializable()
class MidSyllabus {
  final List<String> topics;
  final String midDate;

  MidSyllabus({
    required this.topics,
    required this.midDate,
  });

  factory MidSyllabus.fromJson(Map<String, dynamic> json) =>
      _$MidSyllabusFromJson(json);
  Map<String, dynamic> toJson() => _$MidSyllabusToJson(this);
}
