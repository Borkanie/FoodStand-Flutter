import 'dart:convert';

import 'package:claro_server/Abstractions/ifood_service.dart';
import 'package:claro_server/JSON/food_service.dart';
import 'package:test/test.dart';
import 'dart:io';
import 'package:mockito/mockito.dart';

// Import the generated mock
import 'mocks.mocks.dart';

// Custom Mock Class
class MockFile extends Mock implements File {
  String _content = '';
  
  @override
  String get path => "DUMMY";

  @override
  Future<File> writeAsString(String contents, {FileMode mode = FileMode.write, Encoding encoding = utf8, bool flush = false}) {
    _content = contents;
    Future.delayed(Duration(milliseconds: 10));
    return Future(() => this);
  }

  @override
  Future<String> readAsString({Encoding encoding = utf8}) {
    return Future(() => _content);
  }
  
  @override
  Future<bool> exists() {
    return Future(() => true);
  }

}

// Helper function to load the mock data
Future<String> loadMockData(String fileName) async {
  return await  File('test/mock_data/$fileName').readAsString();
}

void main() {
  group('0 Items in DBB', () {
    String currentMockFile = 'mock_0_food_data.json';
    print('Running group with 0 items');
    _runFoodServiceFullTestingSuite(currentMockFile, true);
    print('Group with 0 items is done');
  });

  group('16 items in DBB', () {
    String currentMockFile = 'mock_16_food_data.json';
    print('Running group with 16 items');
    _runFoodServiceFullTestingSuite(currentMockFile, false);
    print('Running group with 16 items');
  });
}

void _runFoodServiceFullTestingSuite(String currentMockFile, bool expectEmpty) async {
  print("intialized Mock File");
  MockFile mockFile = MockFile();
  IFoodService service;

  // Load mock data from the file synchronously
  final mockContent = _loadMockDataSync(currentMockFile); 
  mockFile.writeAsString(mockContent);
  service = await FoodService.intitialize(mockFile);
  
  _commonTest(mockFile, expectEmpty, service);

  if(!expectEmpty){
    test('Get Pizza', () {
      _getFoodThatWasRegistered(mockFile, service, "Pizza");
    });

    test('Remove Pizza returned by getFood(Pizza)', () {
      _removeFoodExistingFoodInstance(mockFile, service);
    });

    test('Remove Pizza by name should work', () {
      _removeFoodExistingFoodByNameInstance(mockFile, service);
    });

    test('Remove NONEXISTENT by name should work', () {
      _removeFoodNONExistentFoodByNameInstance(mockFile, service);
    });
    
    test('Remove DEFAULT by FOOD should work', () {
      _removeFoodDefaultFoodInstance(mockFile, service);
    });
  }  
}

void _commonTest(MockFile mockFile, bool expectEmpty, IFoodService service) {
  test('should read file and return a list of Food objects', () {
    _testMockFileSanity(mockFile, expectEmpty);
  });
  
  test('Get UNREGISTERED result in default Food', () {
    _getFoodThatWasNotRegistered(mockFile, service, "UNREGISTERED");
  });

  test('Register a new food in the service', () {
    _registerFoodUnregisteredInstance(mockFile, service);
  });
}

// Helper function to load mock data synchronously
String _loadMockDataSync(String fileName) {
  return File('test/mock_data/$fileName').readAsStringSync(); // Synchronously read file
}

void _removeFoodNONExistentFoodByNameInstance(MockFile mockFile, IFoodService service) async {
  service.removeFood(name: "NONERROR");

  //Assertion
  expect((await service.getFood("NONERROR")).name, "");
  var contents = await mockFile.readAsString();
  expect(contents.contains("NONERROR"), false);
}

void _removeFoodDefaultFoodInstance(MockFile mockFile, IFoodService service) async {
  var food = await service.getFood("");
  service.removeFood(food: food);

  //Assertion
  expect((await service.getFood(food.name)).name, "");
  var contents = await mockFile.readAsString();
  expect(contents.contains(food.name), false);
}

void _removeFoodExistingFoodByNameInstance(MockFile mockFile, IFoodService service) async {
  service.removeFood(name: "Pizza");

  //Assertion
  expect((await service.getFood("Pizza")).name, "");
  var contents = await mockFile.readAsString();
  expect(contents.contains("Pizza"), false);
}

void _removeFoodExistingFoodInstance(MockFile mockFile, IFoodService service) async {
  var food = await service.getFood("Pizza");
  service.removeFood(food: food);

  //Assertion
  expect((await service.getFood(food.name)).name, "");
  var contents = await mockFile.readAsString();
  expect(contents.contains(food.name), false);
}

void _registerFoodUnregisteredInstance(MockFile mockFile, IFoodService service) async {
  var food = await service.getFood("");
  food.name = "TESTING FOOD";
  food.weigthPerPortion = 100;
  food.pricePerPortion = 100;
  food.description = "123123";
  service.registerFood(food);

  //Assertion
  expect((await service.getFood(food.name)).name, food.name);
  var contents = await mockFile.readAsString();
  expect(contents.contains(food.name), true);
}

/// Runs [FoodService.getFood] expecting a [Food] instance
void _getFoodThatWasRegistered(MockFile mockFile, IFoodService service,String foodName) async {
  var food =await service.getFood(foodName);

  // Assertions
  expect(food.name == foodName, isTrue);
}

/// Runs [FoodService.getFood] expecting default result.
void _getFoodThatWasNotRegistered(MockFile mockFile, IFoodService service, String foodName) async {
  var food =await service.getFood(foodName);

  // Assertions
  expect(food.name == "", isTrue);
}

/// Makes sure file has expected values
void _testMockFileSanity(MockFile mockFile, bool expectEmpty) async {
  final exists = await mockFile.exists();
  final content = await mockFile.readAsString();
  
  // Assertions
  expect(exists, isTrue);
  if(!expectEmpty) {
    expect(content.contains('Pizza'), isTrue);
  }
} 