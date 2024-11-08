import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:claro_server/Abstractions/ilocalization_service.dart';
import 'package:claro_server/Data/change.dart';
import 'package:claro_server/Data/container.dart';
import 'package:claro_server/Data/food.dart';
import 'package:claro_server/Data/food_map.dart';
import 'package:claro_server/Data/item.dart';
import 'package:claro_server/Data/location.dart';

class LocalizationService extends ILocalizationService{
  final StreamController<Change> _changes;
  final FoodMap _foodMap;
  final File _sourceFile;
  static ILocalizationService? _instance;

  static ILocalizationService get instance {
    if (_instance == null) {
      throw Exception('Singleton is not initialized. Call initialize() first.');
    }
    return _instance!;
  }
  LocalizationService._internal(this._changes, this._foodMap,this._sourceFile); 
  
  // Asynchronous method to read food objects from a file
  static Future<FoodMap> _initializeFoodsFromFile(File file) async {
    final FoodMap foodMap;
    if (await file.exists()) {
      foodMap = FoodMap.fromJson(json.decode(await file.readAsString()));
      return foodMap; 
    }
    throw Exception("Could not read Contianers");  
  }

  static Future<ILocalizationService> intitialize(File file) async {
    final changes =  StreamController<Change>.broadcast();
    var foodMap = await _initializeFoodsFromFile(file);
    _instance = LocalizationService._internal(changes, foodMap, file);
    return  Future(() => instance);
  }

  @override
  Future<void> emitEvent(Change event) {

    return Future( () => _changes.add(event));
  }

  @override
  Future<FoodMap> get getFoodMap{
    return Future(() => _foodMap);
  }

  @override
  Future<Item> getItem(Location location) {
    return Future(() => Item(_foodMap.containers[location]!.food,0));
  }

  @override
  Future<void> pauseSystem() {
    return Future(() => _pause());
  }

  void _pause(){

  }

  @override
  Future<void> readValues() async {
    var currentMap =  await _initializeFoodsFromFile(_sourceFile);
    return Future(() => _streamChangesAsEvents(currentMap));
  }

  void _streamChangesAsEvents(FoodMap newMap){
    for(int i=0;i<newMap.lines;i++){
      for(int j=0;j<newMap.columns;j++){
        var location = Location(i, j);
        _checkDiffBetweenTwoContainersAndEmitEvent(_foodMap.containers[location],newMap.containers[location], location);
      }
    }
  }

  void _checkDiffBetweenTwoContainersAndEmitEvent(Container? source, Container? target, Location location){
        if(source != target){
          if(source == null || target == null){
            return;
          }
          final event;
          if(source.food != target.food){
              event = Change(ChangeTypes.changeFood, location);
          }else{
            event = Change(source.quantity < target.quantity ? ChangeTypes.weigthIncrease : ChangeTypes.weigthDecrease, location);
          }
          // default case is change in wheigth
          emitEvent(event);
        }
  }

  @override
  Future<void> setFood(Food food, Location location) {
    return Future(() => _setFood(food, location));
  }

  void _setFood(Food food, Location location){
    if(!_foodMap.containers.containsKey(location)){
      throw Exception("Location is not registered in the system");
    }
    _foodMap.containers[location]!.food = food;
  }

  @override
  Future<Stream<Change>> subscribe() {
    return Future(() => _changes.stream);
  }

  @override
  void dispose() {
    _changes.close();
  }
}