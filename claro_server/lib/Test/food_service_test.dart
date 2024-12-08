import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:claro_server/Abstractions/ifood_service.dart';
import 'package:claro_server/Data/food.dart';
import 'package:claro_server/JSON/food_service.dart';
// ignore: depend_on_referenced_packages
import 'package:mockito/mockito.dart';
// ignore: depend_on_referenced_packages
import 'package:test/test.dart';


class MockFile extends Mock implements File {

void setFoodMap(String value){
  foodMapJson = value;
}

  var foodMapJson = jsonEncode(
  [
  {
    "name": "Apple",
    "weigthPerPortion": 100,
    "pricePerPortion": 50,
    "description": "A fresh apple"
  },
  {
    "name": "Banana",
    "weigthPerPortion": 120,
    "pricePerPortion": 30,
    "description": "A ripe banana"
  },
  {
    "name": "Orange",
    "weigthPerPortion": 150,
    "pricePerPortion": 40,
    "description": "A juicy orange"
  },
  {
    "name": "Grapes",
    "weigthPerPortion": 200,
    "pricePerPortion": 60,
    "description": "A bunch of grapes"
  }
]);

  @override 
  String get path => "data/food_Service_dbb.json";

  @override
  Future<String> readAsString({Encoding encoding = utf8}) {
    var str = foodMapJson.toString();
    return Future(() => str);
  }

  @override
  String readAsStringSync({Encoding encoding = utf8}) {
    return  foodMapJson.toString();
  }

  @override
  bool existsSync() {
    return true;
  }

  @override
  void createSync({bool recursive = false, bool exclusive = false}) {
    
  }

  @override
  void deleteSync({bool recursive = false}) {
    
  }

  @override
  Future<bool> exists() {
    return Future(() => true);
  }

  @override
  void writeAsStringSync(String contents, {FileMode mode = FileMode.write, Encoding encoding = utf8, bool flush = false}) {
    foodMapJson = contents;
  }


}

void main() {
  late IFoodService foodService;

  setUp(() async {
    // Initialize the FoodService singleton
    final file = MockFile();
    foodService = await FoodService.initialize(file);
  });


  group('FoodService', () {
    test('initializes the singleton instance correctly', () {
      expect(FoodService.instance, isNotNull);
      expect(FoodService.instance, equals(foodService));
    });

    test('adds a new food item', () async {
      final food = Food('Apple33', 100, 50);
      foodService.registerFood(food);

      foodService.getFood(food.name).then((value) =>
      {
      expect(value, equals(food))
      });
    });

    test('does not add duplicate food items', () {
      final food = Food('Apple333', 100, 50);
      foodService.registerFood(food).then((value) => 
      {
        expect(foodService.registerFood(food),throwsA(isA<ArgumentError>()))
      });
    });

    test('updates an existing food item', () {
      final food = Food( 'Apple', 15500, 5550);
      foodService.updateFood(food: food);
      foodService.getFood(food.name).then((value) => expect(value.weigthPerPortion, 15500));
      foodService.getFood(food.name).then((value) => expect(value.pricePerPortion, 5550));
    });

    test('does not update a non-existing food item', () {
      final updatedFood = Food('DUMMY', 150, 60);
      
      expect( foodService.updateFood(food: updatedFood),
        throwsA(isA<ArgumentError>()));
    });

    test('deletes a food item', () async {
      final food = await foodService.getFood("Apple");

      foodService.removeFood(name: food.name).then((value) => 
      {
        foodService.getFood(food.name).then((value) => expect(value , isNull))
      });

    });

    test('does not delete a non-existing food item and does throw exception', () {
      expect(foodService.removeFood(name: "QQQQ"),
             throwsA(isA<ArgumentError>()));
    });

    test('retrieves all food items', () {
      foodService.getFoods().then((onValue) => expect(onValue.length, 4));
    });

    test('returns default when retrieving a non-existing food item by ID', () {
      foodService.getFood("QQQQ").then(
        (value) => expect(value, isNull));
    });
  });
}