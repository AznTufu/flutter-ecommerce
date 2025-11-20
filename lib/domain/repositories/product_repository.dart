import '../../core/utils/result.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Result<List<Product>>> fetchProducts();
  Future<Result<Product>> fetchProductById(String id);
  Future<Result<List<Product>>> searchProducts(String query);
  Future<Result<List<Product>>> filterByCategory(String category);
}
