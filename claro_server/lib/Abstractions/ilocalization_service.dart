import 'package:claro_server/Data/change.dart';
import 'package:claro_server/Data/food.dart';
import 'package:claro_server/Data/food_map.dart';
import 'package:claro_server/Data/container.dart';
import 'package:claro_server/Data/item.dart';
import 'package:claro_server/Data/location.dart';
import 'dart:async';

abstract class ILocalizationService{
  /// Ensures the sensors are reading from the trays.
  void readValues();

  /// Pauses the sensors or the system to allow for maintenance.
  void pauseSystem();

  /// Returns the current [FoodMap]
  Future<FoodMap> get getGoodMap;

  /// Set's a given [Food] item in a [Location] by overriding the current value in the [Container]
  void setFood(Food food, Location location);

  // Method to emit an event
  void emitEvent(Change event);

  /// Method to subscribe to events that signal changes in the [Container]
  Future<Stream<Change>> subscribe();

  /// Returns an [Item] for a [Container] based on it's [Food]
  Future<Item> getItem(Container container);
}