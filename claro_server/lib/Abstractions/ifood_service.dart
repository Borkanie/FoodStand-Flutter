import 'package:claro_server/Data/food.dart';
abstract class IFoodService{
  /// Searches for a [Food] with a matching name and return a new one if none is found
  Future<Food> getFood(String name);
  
  /// returns all the [Food] instances in the database.
  Future<Set<Food>> getFoods();

  /// registers a [Food] object in the database
  Future<void> registerFood(Food food);

  /// udpate s a [Food] in the database, uses the [Food.name] as an identifier
  Future<void> updateFood({required Food food,String? oldName});

  /// udpate s a [Food] in the database, uses the [Food.name] as an identifier or [name] if none matches
  Future<void> removeFood({Food? food,String? name});
  
  /// Checks wheather an item has been registered.
  Future<bool> isRegistered(String name);

  /// returns all the [Food] instances in the database.
  Future<List<Food>> get food;

  //static IFoodService intitialize(File file);
}