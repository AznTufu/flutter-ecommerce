import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../data/datasources/order_local_data_source.dart';
import '../../core/utils/result.dart';

final orderRepositoryProvider = FutureProvider<OrderRepository>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final dataSource = OrderLocalDataSource(prefs);
  return OrderRepositoryImpl(dataSource);
});

final userOrdersProvider = FutureProvider.family<List<Order>, String>((ref, userId) async {
  final repository = await ref.watch(orderRepositoryProvider.future);
  final result = await repository.getUserOrders(userId);
  if (result is Success<List<Order>>) {
    return result.data;
  } else if (result is Failure<List<Order>>) {
    throw Exception(result.message);
  }
  throw Exception('Unknown result type');
});

final orderActionsProvider = FutureProvider<OrderActions>((ref) async {
  final repository = await ref.watch(orderRepositoryProvider.future);
  return OrderActions(repository, ref);
});

class OrderActions {
  final OrderRepository _repository;
  final Ref _ref;

  OrderActions(this._repository, this._ref);

  Future<Order?> createOrder(Order order) async {
    try {
      final result = await _repository.createOrder(order);
      Order? createdOrder;
      if (result is Success<Order>) {
        createdOrder = result.data;
      } else {

        createdOrder = null;
      }
      if (createdOrder != null) {
        _ref.invalidate(userOrdersProvider);
      }
      return createdOrder;
    } catch (error) {
      // Exception: $error
      return null;
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    await _repository.updateOrderStatus(orderId, newStatus);
    _ref.invalidate(userOrdersProvider);
  }

  Future<Order?> getOrderById(String orderId) async {
    final result = await _repository.getOrderById(orderId);
    if (result is Success<Order>) {
      return result.data;
    }
    return null;
  }
}
