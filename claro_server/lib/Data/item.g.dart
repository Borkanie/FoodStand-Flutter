// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      Food.fromJson(json['food'] as Map<String, dynamic>),
      (json['quantity'] as num?)?.toInt(),
    )..price = (json['price'] as num).toInt();

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'food': instance.food,
      'quantity': instance.quantity,
      'price': instance.price,
    };
