// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'container.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Container _$ContainerFromJson(Map<String, dynamic> json) => Container(
      Food.fromJson(json['food'] as Map<String, dynamic>),
      (json['quantity'] as num).toInt(),
      $enumDecode(_$PortionTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$ContainerToJson(Container instance) => <String, dynamic>{
      'food': instance.food,
      'quantity': instance.quantity,
      'type': _$PortionTypeEnumMap[instance.type]!,
    };

const _$PortionTypeEnumMap = {
  PortionType.g: 'g',
  PortionType.portion: 'portion',
};
