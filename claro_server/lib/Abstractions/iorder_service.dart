import 'package:claro_server/Data/item.dart';
import 'package:claro_server/Data/order.dart';

abstract class IOrderService{
  /// returns an order with a given id. If non is existant it creates a new one.  
  Future<Order> getOrder(int? id);

  /// Adds an [Item] to an [Order] based on the order's id. 
  Future<void> addItem(Item item,int orderid); 

  /// Removes an [Item] to an [Order] based on the order's id. 
  Future<void> removeItem(Item item,int orderId); 

  /// Deletes an [Order] idntified by it's [Order.id] or by the [id] if none was found before.
  Future<void> deleteOpenOrder({Order? order,int? id});

  /// Closes an roder and creates the reciept.
  Future<void> closeOrder({Order? order,int? id});
}