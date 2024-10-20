import 'package:claro_server/Data/container.dart';
import 'package:claro_server/Data/location.dart';

/// This object holds a colleciton of [Container] in a matrix like format using a [Map]
/// It set's a fixed [lines] and [columns] on construction to frame the matrix.
/// The Map will use the [Location] of each container  as the key.
class FoodMap{
  Map<Location,Container> containers;
  final int lines;
  final int columns;
  FoodMap(this.containers, this.lines, this.columns);
  FoodMap get clone{
    Map<Location,Container> containerList = {};
    for(var key in containers.keys){
      var newContainer = Container(containers[key]!.food, containers[key]!.wheigth, containers[key]!.type, key);
      containerList[key]=newContainer;
    }
    FoodMap result = FoodMap(containerList, lines, columns);
    return result;
  }
 
  @override
  int get hashCode{
    int res = 0;
    for(var key in containers.keys){
      res += containers[key].hashCode * key.hashCode;
    }
    return res;
  }

  @override 
  bool operator ==(Object other){
    return other is FoodMap ? other.hashCode == hashCode : false;
  }
}


