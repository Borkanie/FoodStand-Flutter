import 'package:claro_server/Data/food.dart';
import 'package:claro_server/Data/item.dart';


/// Contains a [List] of [Item] and represents an order for a given customer with all it's items.
class Order{
  List<Item> items = [];
  int price = 0;
  List<Food> get getFoods{
    List<Food> result = [];
    for(var item in items){
      result.add(item.food);
    }
    return result;
  }
}