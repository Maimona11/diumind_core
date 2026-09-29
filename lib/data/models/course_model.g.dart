// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Course _$CourseFromJson(Map<String, dynamic> json) => Course(
  id: json['id'] as String,
  code: json['code'] as String,
  name: json['name'] as String,
  instructor: json['instructor'] as String,
  credits: (json['credits'] as num).toInt(),
  room: json['room'] as String,
  schedule: (json['schedule'] as List<dynamic>)
      .map((e) => ClassSchedule.fromJson(e as Map<String, dynamic>))
      .toList(),
  midSyllabus: json['midSyllabus'] == null
      ? null
      : MidSyllabus.fromJson(json['midSyllabus'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'name': instance.name,
  'instructor': instance.instructor,
  'credits': instance.credits,
  'room': instance.room,
  'schedule': instance.schedule,
  'midSyllabus': instance.midSyllabus,
};

ClassSchedule _$ClassScheduleFromJson(Map<String, dynamic> json) =>
    ClassSchedule(
      courseId: json['courseId'] as String,
      day: json['day'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      room: json['room'] as String,
    );

Map<String, dynamic> _$ClassScheduleToJson(ClassSchedule instance) =>
    <String, dynamic>{
      'courseId': instance.courseId,
      'day': instance.day,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'room': instance.room,
    };

MidSyllabus _$MidSyllabusFromJson(Map<String, dynamic> json) => MidSyllabus(
  topics: (json['topics'] as List<dynamic>).map((e) => e as String).toList(),
  midDate: json['midDate'] as String,
);

Map<String, dynamic> _$MidSyllabusToJson(MidSyllabus instance) =>
    <String, dynamic>{'topics': instance.topics, 'midDate': instance.midDate};
