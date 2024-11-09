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
    {
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
]});

  @override
  Future<String> readAsString({Encoding encoding = utf8}) {
    var str = foodMapJson.toString();
    return Future(() => str);
  }

  @override
  Future<bool> exists() {
    return Future(() => true);
  }


}

void main() {
  late IFoodService foodService;
  final String databaseFilePath = 'path/to/database/file';

  setUp(() {
    // Initialize the FoodService singleton
    FoodService.initialize(MockFile());
    foodService = FoodService.instance;
  });


  group('FoodService', () {
    test('initializes the singleton instance correctly', () {
      expect(FoodService.instance, isNotNull);
      expect(FoodService.instance, equals(foodService));
    });

    test('adds a new food item', () {
      final food = Food('Apple33', 100, 50);
      foodService.registerFood(food);

      expect(foodService.getFood(food.name), equals(food));
    });

    test('does not add duplicate food items', () {
      final food = Food('Apple333', 100, 50);
      foodService.registerFood(food);
      expect(() async =>await foodService.registerFood(food), 
                  throwsException);
    });

    test('updates an existing food item', () {
      final food = Food( 'Apple', 15500, 5550);
      foodService.updateFood(food: food);
      foodService.getFood(food.name).then((value) => expect(value.weigthPerPortion, 15500));
      foodService.getFood(food.name).then((value) => expect(value.pricePerPortion, 5550));
    });

    test('does not update a non-existing food item', () {
      final updatedFood = Food('DUMMY', 150, 60);
      
      expect(() async => await foodService.updateFood(food: updatedFood),
        throwsException);
    });

    test('deletes a food item', () async {
      final food = await foodService.getFood("Apple");

      foodService.removeFood(name: food.name);

      expect(await foodService.getFood(food.name), isNull);
    });

    test('does not delete a non-existing food item and does throw exception', () {
      expect(() async => await foodService.removeFood(name: "QQQQ"), throwsException);
    });

    test('retrieves all food items', () {
      foodService.getFoods().then((onValue) => expect(onValue.length, 4));
    });

    test('returns default when retrieving a non-existing food item by ID', () {
      final result = foodService.getFood("QQQQ");
      expect(result, Food("", 0, 0));
    });
  });
}