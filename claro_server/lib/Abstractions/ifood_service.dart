import 'package:claro_server/Data/food.dart';
abstract class IFoodService{
  /// Searches for a [Food] with a matching name and return a new one if none is found
  Food getFood(String? name);
  
  /// registers a [Food] object in the database, return [True] if succesfull
  bool registerFood(Food food);

  /// udpate s a [Food] in the database, uses the [Food.name] as an identifier
  bool updateFood(Food food,String? oldName);

  /// udpate s a [Food] in the database, uses the [Food.name] as an identifier or [name] if none matches
  bool removeFood(Food? food,String? name);
  
  /// returns all the [Food] isntances in the database.
  List<Food> get food;
}