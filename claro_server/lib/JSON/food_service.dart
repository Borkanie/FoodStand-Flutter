import 'package:claro_server/Abstractions/ifood_service.dart';
import 'package:claro_server/Data/food.dart';

class FoodService extends IFoodService {
  List<Food> _food = new List.empty();
  
  @override
  List<Food> get food => _food;

  @override
  Food getFood(String? name) {
    // TODO: implement getFood
    throw UnimplementedError();
  }

  @override
  bool registerFood(Food food) {
    // TODO: implement registerFood
    throw UnimplementedError();
  }

  @override
  bool removeFood(Food? food, String? name) {
    // TODO: implement removeFood
    throw UnimplementedError();
  }

  @override
  bool updateFood(Food food, String? oldName) {
    // TODO: implement updateFood
    throw UnimplementedError();
  }

}