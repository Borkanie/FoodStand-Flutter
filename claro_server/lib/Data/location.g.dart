// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      (json['line'] as num).toInt(),
      (json['column'] as num).toInt(),
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'line': instance.line,
      'column': instance.column,
    };
