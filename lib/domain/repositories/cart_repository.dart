import '../../core/utils/result.dart';
import '../entities/cart_item.dart';

abstract class CartRepository {
  Future<Result<List<CartItem>>> getCart();
  Future<Result<void>> addToCart(CartItem item);
  Future<Result<void>> updateQuantity(String productId, int quantity);
  Future<Result<void>> removeFromCart(String productId);
  Future<Result<void>> clearCart();
  Future<Result<double>> getCartTotal();
}
