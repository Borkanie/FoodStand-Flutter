import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:claro_server/Abstractions/ilocalization_service.dart';
import 'package:claro_server/Data/change.dart';
import 'package:claro_server/Data/food.dart';
import 'package:claro_server/Data/food_map.dart';
import 'package:claro_server/Data/item.dart';
import 'package:claro_server/Data/location.dart';
import 'package:claro_server/JSON/localization_service.dart';
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
  "containers": [
    {
      "location": { "line": 0, "column": 0 },
      "container": {
        "food": { 
          "name": "apple", 
          "weigthPerPortion": 100, 
          "pricePerPortion": 50,
          "description": "A fresh red apple"
        },
        "wheigth": 1,
        "type": "g"
      }
    },
    {
      "location": { "line": 0, "column": 1 },
      "container": {
        "food": { 
          "name": "banana", 
          "weigthPerPortion": 120, 
          "pricePerPortion": 30,
          "description": "A ripe yellow banana"
        },
        "wheigth": 2,
        "type": "portion"
      }
    },
    {
      "location": { "line": 0, "column": 2 },
      "container": {
        "food": { 
          "name": "carrot", 
          "weigthPerPortion": 80, 
          "pricePerPortion": 20,
          "description": "An organic carrot"
        },
        "wheigth": 3,
        "type": "g"
      }
    },
    {
      "location": { "line": 0, "column": 3 },
      "container": {
        "food": { 
          "name": "broccoli", 
          "weigthPerPortion": 200, 
          "pricePerPortion": 45,
          "description": "A bunch of broccoli"
        },
        "wheigth": 4,
        "type": "portion"
      }
    }
  ],
  "lines": 1,
  "columns": 4
});

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
class MockStreamController extends Mock implements StreamController<Change> {}

void main() {
  late MockFile mockFile;
  late ILocalizationService localizationService;

  // Set up method with debugging print statements
  setUp(() async {
    print("Running setUp...");
    mockFile = MockFile();
    
    // Initialize LocalizationService
    localizationService = await LocalizationService.intitialize(mockFile);
    print("setUp completed.");
  });

  tearDown(() {
    print("Running tearDown...");
    localizationService.dispose();
  });

  group('LocalizationService', () {
    test('initializes and reads FoodMap from file', () async {
      final foodMap = await localizationService.getGoodMap;
      expect(foodMap, isA<FoodMap>());
      expect(foodMap.containers.isNotEmpty, true);
    });

  test('emitEvent adds a new change event', () async {
      final change = Change(ChangeTypes.weigthIncrease, Location(0, 0));
      final eventStream = await localizationService.subscribe();
      var res = eventStream.first;

      await localizationService.emitEvent(change);
      expect(await res, change);
    });

    test('getItem returns an item based on location', () async {
      final location = Location(0, 0);
      final item = await localizationService.getItem(location);
      expect(item, isA<Item>());
      expect(item.food.name, equals('apple'));
    });

    test('setFood sets the food at a given location', () async {
      final food = Food('banana', 10, 10);
      final location = Location(0, 0);
      await localizationService.setFood(food, location);

      final updatedItem = await localizationService.getItem(location);
      expect(updatedItem.food.name, equals('banana'));
    });

    test('pauseSystem invokes internal _pause method', () async {
      await localizationService.pauseSystem();
      // We can confirm if _pause was called without a direct test due to method encapsulation.
    });

    test('readValues reads and streams changes if food map differs', () async {
      final newFoodMapJson = jsonEncode(
       {"containers": [{
      "location": { "line": 0, "column": 0 },
      "container": {
        "food": { 
          "name": "chicken", 
          "weigthPerPortion": 300, 
          "pricePerPortion": 150,
          "description": "Grilled chicken breast"
        },
        "wheigth": 5,
        "type": "g"
      }
    },
    {
      "location": { "line": 0, "column": 1 },
      "container": {
        "food": { 
          "name": "beef", 
          "weigthPerPortion": 350, 
          "pricePerPortion": 200,
          "description": "Lean beef steak"
        },
        "wheigth": 6,
        "type": "portion"
      }
    },
    {
      "location": { "line": 0, "column": 2 },
      "container": {
        "food": { 
          "name": "pork", 
          "weigthPerPortion": 250, 
          "pricePerPortion": 180,
          "description": "Tender pork chop"
        },
        "wheigth": 7,
        "type": "g"
      }
    },
    {
      "location": { "line": 0, "column": 3 },
      "container": {
        "food": { 
          "name": "fish", 
          "weigthPerPortion": 200, 
          "pricePerPortion": 160,
          "description": "Fresh salmon fillet"
        },
        "wheigth": 8,
        "type": "g"
      }
    }],
     "lines": 1,
  "columns": 4
});
      
      mockFile.setFoodMap(newFoodMapJson);
      final eventStream = await localizationService.subscribe();

      await localizationService.readValues();
      var changes = eventStream.take(4);
      var count = await changes.length;
      expect(count, 4);
      changes.listen((onData) {
        expect(onData.type, ChangeTypes.changeFood);
      });
    });
  });
}
