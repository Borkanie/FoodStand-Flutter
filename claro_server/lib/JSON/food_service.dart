import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:claro_server/Abstractions/ifood_service.dart';
import 'package:claro_server/Data/food.dart';

class FoodService extends IFoodService {
  final LinkedHashSet<Food> _foods;
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
      Future<List<Food>>(() => _foods.toList());

  @override
  Future<Food> getFood(String name) {
    return Future(() =>  _foods.firstWhere( (x) => x.name == name));
  }

  @override
  Future<bool> isRegistered(String name) {
    return Future(() => _foods.any((food) => food.name == name));
  }

  @override
  Future<void> registerFood(Food food) {
    return Future(() => _registerFood(food));
  }

  void _removeFood({Food? food, String? name}) {
    // Check if both parameters are null
    if (food == null && name == null) {
      throw ArgumentError('At least one argument (food or name) must be provided.');
    }
    if(!_foods.any((x) => name == null ? x.name == food!.name : x.name == name)){
      throw ArgumentError('Food with name ${name ?? food!.name} does not exist.');
    }
    name == null ? _foods.removeWhere((x) => x.name == name) : _foods.removeWhere((x) => x.name == food!.name);
    _saveMap();
  }

  @override
  Future<void> removeFood({Food? food, String? name}) {
    return Future(() => _removeFood(food: food,name: name));
  }

  void _updateFood({required Food food, String? oldName}) {
    if(_foods.any((x) => x.name == food.name)){
      if(oldName == null && _foods.any((x) => x.name == oldName)){
        throw ArgumentError('Food with name ${oldName ?? food.name} already exists.');
      }
    }else if(!_foods.any((x) => x.name == oldName)){
      throw ArgumentError('Food with name ${oldName ?? food.name} already exists.');
    }
    oldName == null ? _foods.removeWhere((x) => x.name == food.name) : _foods.removeWhere((x) => x.name == oldName);
    _foods.add(food);
    _saveMap();
  }

  @override
  Future<void> updateFood({required Food food, String? oldName}) {
    return Future(() => _updateFood(food: food,oldName: oldName));
  }

  void _registerFood(Food food) {
    if(_foods.any((x) => x.name == food.name)){
      throw ArgumentError('Food with name ${food.name} already exists.');
    }
    _foods.add(food);
    _saveMap();
  }

  // Factory constructor to create an instance with async initialization
  static Future<IFoodService> initialize(File file) async {
    LinkedHashSet<Food> foodList = await _initializeFoodsFromFile(file);
    _instance = FoodService._internal(foodList, file.path);
    return  Future(() => instance);
  }

  // Asynchronous method to read food objects from a file
  static Future<LinkedHashSet<Food>> _initializeFoodsFromFile(File file) async {
    final LinkedHashSet<Food> list = LinkedHashSet.identity();
    if (file.existsSync()) {
      var fileString = file.readAsStringSync();
      final List<dynamic> jsonList = json.decode(fileString);
      if(jsonList.isNotEmpty){
        jsonList
          .map((json) => Food.fromJson(json))
          .toList()
          .forEach((member) => list.add(member));
      } 
    }
    return list;
  }

  Future<File> _saveMap() async {
    var file = File(_dataBaseFilePath);
    if(file.existsSync()){
      file.deleteSync();
    }
    file.createSync();
    List<Food> jsonMap = _foods.toList();
    // Convert the map to a JSON string
    String jsonString = jsonEncode(jsonMap);
    return file.writeAsString(jsonString);
  }
  
  @override
  Future<Set<Food>> getFoods() {
    return Future(() => _foods);
  }
}
