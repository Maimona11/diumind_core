// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Student _$StudentFromJson(Map<String, dynamic> json) => Student(
  id: json['id'] as String,
  name: json['name'] as String,
  department: json['department'] as String,
  semester: json['semester'] as String,
  email: json['email'] as String,
  enrolledCourses: (json['enrolledCourses'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$StudentToJson(Student instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'department': instance.department,
  'semester': instance.semester,
  'email': instance.email,
  'enrolledCourses': instance.enrolledCourses,
};
