import 'package:claro_server/Data/food.dart';
import 'package:claro_server/Data/order.dart';

/// An Item is a wrapper around a [Food] in the contrxt of an [Order]
class Item{
  Food food;
  int quantity = 0;
  int price;
  Item(this.food,int? quantity) : quantity = quantity ?? 0, // Initialize quantity
        price = (quantity ?? 0) * food.pricePerPortion; // Initialize price
}