// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quiz _$QuizFromJson(Map<String, dynamic> json) => Quiz(
  id: json['id'] as String,
  courseId: json['courseId'] as String,
  courseCode: json['courseCode'] as String,
  title: json['title'] as String,
  date: json['date'] as String,
  topics: json['topics'] as String,
  marks: (json['marks'] as num).toInt(),
);

Map<String, dynamic> _$QuizToJson(Quiz instance) => <String, dynamic>{
  'id': instance.id,
  'courseId': instance.courseId,
  'courseCode': instance.courseCode,
  'title': instance.title,
  'date': instance.date,
  'topics': instance.topics,
  'marks': instance.marks,
};
