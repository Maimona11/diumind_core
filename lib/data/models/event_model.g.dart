// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CampusEvent _$CampusEventFromJson(Map<String, dynamic> json) => CampusEvent(
  id: json['id'] as String,
  title: json['title'] as String,
  date: json['date'] as String,
  location: json['location'] as String,
  description: json['description'] as String,
);

Map<String, dynamic> _$CampusEventToJson(CampusEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'date': instance.date,
      'location': instance.location,
      'description': instance.description,
    };
