import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/order.dart';

class OrderLocalDataSource {
  static const String _ordersKey = 'orders';

  final SharedPreferences _prefs;

  OrderLocalDataSource(this._prefs);
  Future<void> saveOrder(Order order) async {
    final orders = await getOrders();
    orders.add(order);

    final ordersJson = orders.map((o) => o.toJson()).toList();
    await _prefs.setString(_ordersKey, jsonEncode(ordersJson));
  }
  Future<List<Order>> getOrders() async {
    final ordersString = _prefs.getString(_ordersKey);
    if (ordersString == null) return [];

    try {
      final List<dynamic> ordersJson = jsonDecode(ordersString);
      return ordersJson.map((json) => Order.fromJson(json)).toList();
    } catch (e) {
      print('Erreur lors du parsing des commandes: $e');
      return [];
    }
  }
  Future<List<Order>> getOrdersByUserId(String userId) async {
    final allOrders = await getOrders();
    return allOrders.where((order) => order.userId == userId).toList();
  }
  Future<Order?> getOrderById(String orderId) async {
    final orders = await getOrders();
    try {
      return orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }
  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    final orders = await getOrders();
    final orderIndex = orders.indexWhere((order) => order.id == orderId);

    if (orderIndex != -1) {
      final updatedOrder = Order(
        id: orders[orderIndex].id,
        userId: orders[orderIndex].userId,
        items: orders[orderIndex].items,
        totalAmount: orders[orderIndex].totalAmount,
        status: newStatus,
        createdAt: orders[orderIndex].createdAt,
        shippingAddress: orders[orderIndex].shippingAddress,
        shippingCity: orders[orderIndex].shippingCity,
        shippingPostalCode: orders[orderIndex].shippingPostalCode,
        shippingName: orders[orderIndex].shippingName,
      );

      orders[orderIndex] = updatedOrder;

      orders[orderIndex] = updatedOrder;

      final ordersJson = orders.map((o) => o.toJson()).toList();
      await _prefs.setString(_ordersKey, jsonEncode(ordersJson));
    }
  }
  Future<void> clearOrders() async {
    await _prefs.remove(_ordersKey);
  }
  Future<void> deleteOrder(String orderId) async {
    final orders = await getOrders();
    orders.removeWhere((order) => order.id == orderId);

    final ordersJson = orders.map((o) => o.toJson()).toList();
    await _prefs.setString(_ordersKey, jsonEncode(ordersJson));
  }
}
