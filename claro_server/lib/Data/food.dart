import 'package:json_annotation/json_annotation.dart';

part 'food.g.dart';

/// I meant it's food:)
@JsonSerializable()
class Food{
  static Food getDefault = Food("Empty", 0, 0);
  int _wheigthPerPortion;
  int _pricePerPortion;
  String name;
  String? description;
  Food(this.name,int wheigthPerPortion,int pricePerPortion) : _wheigthPerPortion = 0, _pricePerPortion = 0
  {
    wheigthPerPortion > 0 ? _wheigthPerPortion = wheigthPerPortion : _wheigthPerPortion = -wheigthPerPortion;
    pricePerPortion > 0 ? _pricePerPortion = wheigthPerPortion : _pricePerPortion = -pricePerPortion;
  }
  
  @override
  int get hashCode => name.hashCode * (wheigthPerPortion + 1) * (pricePerPortion + 1);
  
  int get pricePerPortion => _pricePerPortion;
  set pricePerPortion(int value){
    value > 0 ? _pricePerPortion = value : _pricePerPortion = -value;
  }

  int get wheigthPerPortion => _wheigthPerPortion;
  set wheigthPerPortion(int value){
    value > 0 ? _wheigthPerPortion = value : _wheigthPerPortion = -value;
  }

  @override
  bool operator ==(Object other) {
    return other is Food ? other .hashCode == hashCode : false;
  }

  factory Food.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);
  Map<String, dynamic> toJson() => _$FoodToJson(this);
}