// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Food _$FoodFromJson(Map<String, dynamic> json) => Food(
      json['name'] as String,
      (json['wheigthPerPortion'] as num).toInt(),
      (json['pricePerPortion'] as num).toInt(),
    )..description = json['description'] as String?;

Map<String, dynamic> _$FoodToJson(Food instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'pricePerPortion': instance.pricePerPortion,
      'wheigthPerPortion': instance.wheigthPerPortion,
    };
