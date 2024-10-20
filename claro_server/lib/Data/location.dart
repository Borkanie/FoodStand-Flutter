import 'package:claro_server/Data/food.dart';
import 'package:claro_server/Data/Container.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

/// This class will deal with the position of a [Container]
///  in a matrix that represents the trays of [Food].
@JsonSerializable()
class Location{
  /// The line on which the [Container] can be found.
  int line;

  /// The column on which the [Container] can be found.
  int column;
  
  Location(this.line, this.column);

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
