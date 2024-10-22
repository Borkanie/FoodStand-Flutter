import 'package:claro_server/Data/food.dart';
import 'package:claro_server/Data/container.dart';

/// This class will deal with the position of a [Container]
///  in a matrix that represents the trays of [Food].
class Location{
  /// The line on which the [Container] can be found.
  int line;

  /// The column on which the [Container] can be found.
  int column;
  
  Location(this.line, this.column);
  
  factory Location.fromJson(Map<String, dynamic> json) => Location(
      (json['line'] as num).toInt(),
      (json['column'] as num).toInt(),
    );

  Map<String, dynamic> toJson()=> <String, dynamic>{
      'line': line,
      'column': column,
    };
}
