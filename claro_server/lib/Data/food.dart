import 'package:json_annotation/json_annotation.dart';

part 'food.g.dart';

/// I meant it's food:)
@JsonSerializable()
class Food{
  static Food getDefault = Food("Empty", 0, 0);
  int _weigthPerPortion;
  int _pricePerPortion;
  String name;
  String? description;
  Food(this.name,int weigthPerPortion,int pricePerPortion) : _weigthPerPortion = 0, _pricePerPortion = 0
  {
    weigthPerPortion > 0 ? _weigthPerPortion = weigthPerPortion : _weigthPerPortion = -weigthPerPortion;
    pricePerPortion > 0 ? _pricePerPortion = weigthPerPortion : _pricePerPortion = -pricePerPortion;
  }
  
  @override
  int get hashCode => name.hashCode * (weigthPerPortion + 1) * (pricePerPortion + 1);
  
  int get pricePerPortion => _pricePerPortion;
  set pricePerPortion(int value){
    value > 0 ? _pricePerPortion = value : _pricePerPortion = -value;
  }

  int get weigthPerPortion => _weigthPerPortion;
  set weigthPerPortion(int value){
    value > 0 ? _weigthPerPortion = value : _weigthPerPortion = -value;
  }

  @override
  bool operator ==(Object other) {
    return other is Food ? other .hashCode == hashCode : false;
  }

  factory Food.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);
  Map<String, dynamic> toJson() => _$FoodToJson(this);
}