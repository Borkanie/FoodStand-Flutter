import 'package:claro_server/Data/food.dart';
import 'package:json_annotation/json_annotation.dart';

part 'container.g.dart';

/// This object represents a tray equiped with a sensor.
/// It must have food in it.
/// In case of empty  we will use default food.
@JsonSerializable()
class Container{
  Food food;
  int quantity;
  PortionType type;
  Container(this.food,this.quantity,this.type);

  /// Returns the avialable food poritons for the given food.
  int get avialableQuantity{
    if(type == PortionType.portion) {
      return quantity ~/ food.weigthPerPortion;
    } else {
      return quantity;
    }
  }

  @override
  int get hashCode => food.hashCode;

  @override operator==(Object other){
    return other is Container ? (other.food == food && other.quantity == quantity && other.type == type) : false;
  }

  factory Container.fromJson(Map<String, dynamic> json) => _$ContainerFromJson(json);
  Map<String, dynamic> toJson() => _$ContainerToJson(this);
}

/// Divides poritoning types into wheigthed and piced meals.
enum PortionType{
  g,
  portion
}