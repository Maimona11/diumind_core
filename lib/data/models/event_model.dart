import 'package:json_annotation/json_annotation.dart';

part 'event_model.g.dart';

@JsonSerializable()
class CampusEvent {
  final String id;
  final String title;
  final String date;
  final String location;
  final String description;

  CampusEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.description,
  });

  factory CampusEvent.fromJson(Map<String, dynamic> json) =>
      _$CampusEventFromJson(json);
  Map<String, dynamic> toJson() => _$CampusEventToJson(this);
}
