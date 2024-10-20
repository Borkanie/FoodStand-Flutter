import 'dart:convert';
import 'dart:io';

import 'package:claro_server/Abstractions/ifood_service.dart';
import 'package:claro_server/Data/food.dart';

class FoodService extends IFoodService {
  final List<Food> _food;
  
  FoodService(this._food);


  @override
  Future<List<Food>> get food => Future<List<Food>>(() => _food);

  @override
  Future<Food> getFood(String name) {
    return Future( () => _getFood(name));
  }

  @override
  Future<bool> registerFood(Food food) {
   return Future(() => _registerFood(food));
  }

  @override
  Future<bool> removeFood(Food? food, String? name) {
    return Future(() => _removeFood(food,name));
  }

  @override
  Future<bool> updateFood(Food food, String? oldName) {
    return Future(()=> _updateFood(food,oldName));
  }

  Food _getFood(String name){
    return _food.firstWhere((food) => food.name == name, orElse: () => Food("",0,0));
  }

  bool _registerFood(Food food){
    if(_getFood(food.name).name == ""){
       _food.add(food);
       return true;
    }else{
      return false;
    }
  }

  bool _removeFood(Food? food, String? name){
    if(food == null && name == null){
      return false;
    }
    if(food == null){
      if(_getFood(name!).name == name){
        _food.remove(_getFood(name));
       return true;
      }else{
        return false;
      }
    }else{
      if(_getFood(food.name).name == ""){
         _food.add(food);
       return true;
      }else{
        return false;
      }
    }
  }

  bool _updateFood(Food food, String? oldName){
    if(oldName == null){
      if(_getFood(food.name).name == ""){
       return false;
      }else{
        _food.remove(_getFood(food.name));
        _food.add(food);
        return true;
      }
    }else{
      if(_getFood(oldName).name == ""){
       return false;
      }else{
        _food.remove(_getFood(oldName));
        _food.add(food);
        return true;
      }
    }
  }

  // Factory constructor to create an instance with async initialization
  static Future<FoodService> create(String filePath) async {
    List<Food> foodList = await _initializeFoodsFromFile(filePath);
    return FoodService(foodList);
  }

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
}