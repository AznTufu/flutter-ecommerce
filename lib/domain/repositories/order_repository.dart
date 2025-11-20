import '../../core/utils/result.dart';
import '../entities/order.dart';

abstract class OrderRepository {
  Future<Result<Order>> createOrder(Order order);
  Future<Result<List<Order>>> getAllOrders();
  Future<Result<List<Order>>> getUserOrders(String userId);
  Future<Result<Order>> getOrderById(String orderId);
  Future<Result<void>> updateOrderStatus(String orderId, OrderStatus newStatus);
}
