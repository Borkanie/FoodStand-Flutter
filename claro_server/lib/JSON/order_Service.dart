import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:claro_server/Abstractions/iorder_service.dart';
import 'package:claro_server/Data/item.dart';
import 'package:claro_server/Data/order.dart';
import 'package:claro_server/util.dart';

class OrderService extends IOrderService{
  final LinkedHashSet<Order> _openOrders;
  final LinkedHashSet<Order> _closedOrders;
  final String _orderCache;
  final String _closedOrdersDBB;

  static IOrderService? _instance;

  OrderService._internal(this._openOrders, this._closedOrders, this._orderCache, this._closedOrdersDBB);

  static IOrderService get instance{
    if (_instance == null) {
      throw Exception('Singleton is not initialized. Call initialize() first.');
    }
    return _instance!;
  }

  // Factory constructor to create an instance with async initialization
  static Future<IOrderService> intitialize(File openOrdersCache,File closedOrderDBB) async {
    final LinkedHashSet<Order> closedOrders = await _initializeFoodsFromFile(closedOrderDBB);
    final LinkedHashSet<Order> openOrders = await _initializeFoodsFromFile(openOrdersCache);
    _instance = OrderService._internal(openOrders, closedOrders, openOrdersCache.path, closedOrderDBB.path);
    return  Future(() => instance);
  }

  // Asynchronous method to read food objects from a file
  static Future<LinkedHashSet<Order>> _initializeFoodsFromFile(File file) async {
    final LinkedHashSet<Order> list = LinkedHashSet.identity();
    if (await file.exists()) {
      final List<dynamic> jsonList = json.decode(await file.readAsString());
      if(jsonList.isNotEmpty){
        jsonList
          .map((json) => Order.fromJson(json))
          .toList()
          .forEach((member) => list.add(member));
      } 
    }
    return list;
  }

  @override
  Future<void> addItem(Item item, int orderid) {
    return Future(() => _addItem(item,orderid));
  }

  void _addItem(Item item, int orderid){
    _openOrders.firstWhere((test) => test.id == orderid).items.add(item);
    _saveCache();
  }

  @override
  Future<void> closeOrder({Order? order, int? id}) {
    return Future(() => _closeOrder(order: order,id: id));
  }

  void _closeOrder({Order? order, int? id}){
    if(order == null && id == null){
      throw Exception("At least One argument of $_closeOrder needs to be not null");
    }
    final Order target = order ?? _openOrders.firstWhere((test) => test.id == id);
    _openOrders.removeWhere((test) => test.id == target.id);
    _saveCache();
    _closedOrders.add(target);
    _saveClosedOrders();
  }

  @override
  Future<void> deleteOpenOrder({Order? order, int? id}) {
   return Future(() =>  _deleteOpenOrder(order, id));
  }

  void _deleteOpenOrder(Order? order, int? id) {
    if(order == null && id == null){
      throw Exception("At least One argument of $_deleteOpenOrder needs to be not null");
    }
    final Order target = order ?? _openOrders.firstWhere((test) => test.id == id);
    _openOrders.removeWhere((test) => test.id == target.id);
    _saveCache();
  }

  @override
  Future<Order> getOrder(int? id) {
    return Future(() => _getOrder(id));
  }

  Order _getOrder(int? id){
    var order = _openOrders.firstWhere((test) => test.id == id, 
                  orElse: () => _closedOrders.firstWhere((test) => test.id == id, orElse: () => Order(0)));
    if(order.id == 0){
      do{
        order = Order(Random().nextInt(1 << 32));
      }
      while(_openOrders.any((element) => element.id == order.id));
      _openOrders.add(order);
      _saveCache();
    }
    return order;
  }

  @override
  Future<void> removeItem(Item item, int orderId) {
    return Future(() => _removeItem(item, orderId));
  }

  void _removeItem(Item item, int orderId){
    _openOrders.firstWhere((test) => test.id == orderId).items.remove(item);
    _saveCache();
  }

  Future<File> _saveCache() async {
    File file = await Util.getEmptyFile(_orderCache);
    List<Order> jsonMap = _openOrders.toList();
    // Convert the map to a JSON string
    String jsonString = jsonEncode(jsonMap);
    return file.writeAsString(jsonString);
  }

  Future<File> _saveClosedOrders() async {
    File file = await Util.getEmptyFile(_closedOrdersDBB);
    List<Order> jsonMap = _closedOrders.toList();
    // Convert the map to a JSON string
    String jsonString = jsonEncode(jsonMap);
    return file.writeAsString(jsonString);
  }
}