import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../../core/utils/result.dart';
import '../datasources/order_local_data_source.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderLocalDataSource _localDataSource;

  OrderRepositoryImpl(this._localDataSource);

  @override
  Future<Result<Order>> createOrder(Order order) async {
    try {
      await _localDataSource.saveOrder(order);
      return Success(order);
    } catch (e) {
      return Failure('Erreur lors de la création de la commande: $e');
    }
  }

  @override
  Future<Result<List<Order>>> getAllOrders() async {
    try {
      final orders = await _localDataSource.getOrders();
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return Success(orders);
    } catch (e) {
      return Failure('Erreur lors de la récupération des commandes: $e');
    }
  }

  @override
  Future<Result<List<Order>>> getUserOrders(String userId) async {
    try {
      final orders = await _localDataSource.getOrdersByUserId(userId);
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return Success(orders);
    } catch (e) {
      return Failure('Erreur lors de la récupération des commandes: $e');
    }
  }

  @override
  Future<Result<Order>> getOrderById(String orderId) async {
    try {
      final order = await _localDataSource.getOrderById(orderId);
      if (order == null) {
        return const Failure('Commande non trouvée');
      }
      return Success(order);
    } catch (e) {
      return Failure('Erreur lors de la récupération de la commande: $e');
    }
  }

  @override
  Future<Result<void>> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      await _localDataSource.updateOrderStatus(orderId, newStatus);
      return const Success(null);
    } catch (e) {
      return Failure('Erreur lors de la mise à jour du statut: $e');
    }
  }
}
