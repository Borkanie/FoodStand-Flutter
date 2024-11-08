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
      var newContainer = Container(containers[key]!.food, containers[key]!.wheigth, containers[key]!.type);
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

  /// Manual `fromJson` method
  factory FoodMap.fromJson(Map<String, dynamic> json) {
    Map<Location, Container> containerMap = {};

    for (var entry in json['containers']) {
      var location = Location.fromJson(entry['location']);  // Assuming Location has a fromJson method
      var container = Container.fromJson(entry['container']);
      containerMap[location] = container;
    }

    return FoodMap(
      containerMap,
      json['lines'] as int,
      json['columns'] as int,
    );
  }
  
 /// Manual `toJson` method
  Map<String, dynamic> toJson() {
    return {
      'containers': containers.entries.map((entry) {
        return {
          'location': entry.key.toJson(),  // Assuming Location has a toJson method
          'container': entry.value.toJson()
        };
      }).toList(),
      'lines': lines,
      'columns': columns,
    };
  }
}


