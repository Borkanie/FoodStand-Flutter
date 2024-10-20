import 'package:claro_server/Data/food.dart';
import 'package:claro_server/Data/location.dart';

/// This object represents a tray equiped with a sensor.
/// It must have food in it.
/// In case of empty  we will use default food.
class Container{
  final Location location;
  Food food;
  int wheigth;
  PortionType type;
  Container(this.food,this.wheigth,this.type,this.location);

  /// Returns the avialable food poritons for the given food.
  int get avialableQuantity{
    if(type == PortionType.portion) {
      return wheigth ~/ food.wheigthPerPortion;
    } else {
      return wheigth;
    }
  }

  @override
  int get hashCode => food.hashCode;

  @override operator==(Object other){
    return other is Container ? other.hashCode == hashCode : false;
  }
}

/// Divides poritoning types into wheigthed and piced meals.
enum PortionType{
  g,
  portion
}