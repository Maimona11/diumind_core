import 'package:json_annotation/json_annotation.dart';

part 'quiz_model.g.dart';

@JsonSerializable()
class Quiz {
  final String id;
  final String courseId;
  final String courseCode;
  final String title;
  final String date;
  final String topics;
  final int marks;

  Quiz({
    required this.id,
    required this.courseId,
    required this.courseCode,
    required this.title,
    required this.date,
    required this.topics,
    required this.marks,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);
  Map<String, dynamic> toJson() => _$QuizToJson(this);
}
