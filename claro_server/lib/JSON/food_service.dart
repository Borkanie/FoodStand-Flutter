import 'package:claro_server/Abstractions/ifood_service.dart';
import 'package:claro_server/Data/food.dart';
import 'dart:io';
import 'dart:convert';

class FoodService extends IFoodService {
  final List<Food> _food;
  
  FoodService(this._food);

  // Asynchronous method to read food objects from a file
  static Future<List<Food>> _initializeFoodsFromFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      return jsonList.map((json) => Food.fromJson(json)).toList();
    }
    return [];
  }

  // Factory constructor to create an instance with async initialization
  static Future<FoodService> create(String filePath) async {
    List<Food> foodList = await _initializeFoodsFromFile(filePath);
    return FoodService(foodList);
  }

  @override
  List<Food> get food => _food;

  @override
  Food getFood(String? name) {
    return _food.firstWhere((food) => food.name == name, orElse: () => Food("",0,0));
  }

  @override
  bool registerFood(Food food) {
    if(getFood(food.name).name == ""){
       _food.add(food);
       return true;
    }else{
      return false;
    }
  }

  @override
  bool removeFood(Food? food, String? name) {
    if(food == null){
       if(getFood(name).name == name){
        _food.remove(getFood(name));
       return true;
      }else{
        return false;
      }
    }else{
      if(getFood(food.name).name == ""){
       _food.add(food);
       return true;
      }else{
        return false;
      }
    }
  }

  @override
  bool updateFood(Food food, String? oldName) {
    if(oldName == null){
       if(getFood(food.name).name == ""){
       return false;
      }else{
        _food.remove(getFood(food.name));
        _food.add(food);
        return true;
      }
    }else{
      if(getFood(oldName).name == ""){
       return false;
      }else{
        _food.remove(getFood(oldName));
        _food.add(food);
        return true;
      }
    }
  }

}