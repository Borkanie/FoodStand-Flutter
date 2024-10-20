// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'container.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Container _$ContainerFromJson(Map<String, dynamic> json) => Container(
      Food.fromJson(json['food'] as Map<String, dynamic>),
      (json['wheigth'] as num).toInt(),
      $enumDecode(_$PortionTypeEnumMap, json['type']),
      Location.fromJson(json['location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ContainerToJson(Container instance) => <String, dynamic>{
      'location': instance.location,
      'food': instance.food,
      'wheigth': instance.wheigth,
      'type': _$PortionTypeEnumMap[instance.type]!,
    };

const _$PortionTypeEnumMap = {
  PortionType.g: 'g',
  PortionType.portion: 'portion',
};
