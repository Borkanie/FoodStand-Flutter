import 'package:claro_server/Data/food.dart';

/// Divides poritoning types into wheigthed and piced meals.
enum PortionType{
  g,
  portion
}

/// This object represents a tray equiped with a sensor.
/// It must have food in it.
/// In case of empty  we will use default food.
class Container{
  Food food;
  int wheigth;
  PortionType type;
  /// Returns the avialable food poritons for the given food.
  int get avialableQuantity{
    if(type == PortionType.portion) {
      return wheigth ~/ food.wheigthPerPortion;
    } else {
      return wheigth;
    }
  }
  Container(this.food,this.wheigth,this.type);
}