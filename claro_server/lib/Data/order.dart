import 'package:claro_server/Data/food.dart';
import 'package:claro_server/Data/item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

/// Contains a [List] of [Item] and represents an order for a given customer with all it's items.
@JsonSerializable()
class Order{
  final int id;
  Order(this.id);
  List<Item> items = [];
  int price = 0;
  List<Food> get getFoods{
    List<Food> result = [];
    for(var item in items){
      result.add(item.food);
    }
    return result;
  }
   factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}