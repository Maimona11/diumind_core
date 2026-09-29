import 'package:json_annotation/json_annotation.dart';

part 'student_model.g.dart';

@JsonSerializable()
class Student {
  final String id;
  final String name;
  final String department;
  final String semester;
  final String email;
  final List<String> enrolledCourses;

  Student({
    required this.id,
    required this.name,
    required this.department,
    required this.semester,
    required this.email,
    required this.enrolledCourses,
  });

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);
  Map<String, dynamic> toJson() => _$StudentToJson(this);
}
