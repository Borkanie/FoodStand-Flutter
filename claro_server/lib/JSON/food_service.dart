import 'dart:convert';
import 'dart:io';

import 'package:claro_server/Abstractions/ifood_service.dart';
import 'package:claro_server/Data/food.dart';

class FoodService extends IFoodService {
  final Map<String, Food> _foods;
  final String _dataBaseFilePath;

  // A static variable to hold the single instance of the class
  static FoodService? _instance;

  // Private named constructor
  FoodService._internal(this._foods, this._dataBaseFilePath);
  
  // Method to get the singleton instance (throws error if not initialized)
  static FoodService get instance {
    if (_instance == null) {
      throw Exception('Singleton is not initialized. Call initialize() first.');
    }
    return _instance!;
  }

  @override
  Future<List<Food>> get food =>
      Future<List<Food>>(() => _foods.values.toList());

  @override
  Future<Food> getFood(String name) {
    return Future(() =>  _foods.containsKey(name) ? _foods[name]! : Food("", 0, 0));
  }

  @override
  Future<bool> isRegistered(String name) {
    return Future(() => _foods.containsKey(name));
  }

  @override
  Future<void> registerFood(Food food) {
    return Future(() => _registerFood(food));
  }

  void _removeFood({Food? food, String? name}) {
    if (name != null && _foods.containsKey(name)) {
      _foods.remove(name);
      _saveMap();
    }
    if (food != null && _foods.containsKey(food.name)) {
      _foods.remove(food.name);
      _saveMap();
    }
  }

  @override
  Future<void> removeFood({Food? food, String? name}) {
    return Future(() => _removeFood(food: food,name: name));
  }

  void _updateFood({required Food food, String? oldName}) {
    if (oldName == null) {
      _foods[food.name] = food;
    } else {
      _foods.remove(oldName);
      _foods[food.name] = food;
    }
    _saveMap();
  }

  @override
  Future<void> updateFood({required Food food, String? oldName}) {
    return Future(() => _updateFood(food: food,oldName: oldName));
  }

  void _registerFood(Food food) {
    _foods[food.name] = food;
  }

  // Factory constructor to create an instance with async initialization
  static Future<IFoodService> intitialize(File file) async {
    Map<String, Food> foodList = await _initializeFoodsFromFile(file);
    _instance = FoodService._internal(foodList, file.path);
    return  Future(() => instance);
  }

  // Asynchronous method to read food objects from a file
  static Future<Map<String, Food>> _initializeFoodsFromFile(File file) async {
    final Map<String, Food> list = {};
    if (await file.exists()) {
      final List<dynamic> jsonList = json.decode(await file.readAsString());
      if(jsonList.isNotEmpty){
        jsonList
          .map((json) => Food.fromJson(json))
          .toList()
          .forEach((member) => list[member.name] = member);
      } 
    }
    return list;
  }

  Future<File> _saveMap() async {
    var file = await _getEmptyFile(_dataBaseFilePath);
    Map<String, dynamic> jsonMap = _foods.map((key, food) => MapEntry(key, food.toJson()));
    // Convert the map to a JSON string
    String jsonString = jsonEncode(jsonMap);
    return file.writeAsString(jsonString);
  }

  Future<File> _getEmptyFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
    await file.create();
    return Future(() => file);
  }
}
