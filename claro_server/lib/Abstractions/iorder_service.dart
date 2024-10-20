import 'package:claro_server/Data/item.dart';
import 'package:claro_server/Data/order.dart';

abstract class IOrderService{
  /// returns an order with a given id. If non is existant it creates a new one.  
  Order getorder(int? id);

  /// Adds an [Item] to an [Order] based on the order's id. 
  bool addItem(Item item,int? orderid); 

  /// Removes an [Item] to an [Order] based on the order's id. 
  bool removeItem(Item item,int? orderid); 

  /// Deletes an [Order] idntified by it's [Order.id] or by the [id] if none was found before.
  bool deleteOrder(Order? order,int? id);

  /// Closes an roder and creates the reciept.
  bool closeOrder(Order? order,int? id);
}