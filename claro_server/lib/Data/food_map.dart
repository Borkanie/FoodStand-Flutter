import 'package:claro_server/Data/container.dart';
import 'package:claro_server/Data/food.dart';

/// This class will deal with the position of a [Container]
///  in a matrix that represents the trays of [Food].
class Location{
  /// The line on which the [Container] can be found.
  int line;

  /// The column on which the [Container] can be found.
  int column;
  
  Location(this.line, this.column);
}


/// This object holds a colleciton of [Container] in a matrix like format using a [Map]
/// It set's a fixed [lines] and [columns] on construction to frame the matrix.
/// The Map will use the [Location] of each container  as the key.
class FoodMap{
  Map<Location,Container> containers;
  final int lines;
  final int columns;
  FoodMap(this.containers, this.lines, this.columns);
}

