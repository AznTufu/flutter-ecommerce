import '../../core/utils/result.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource localDataSource;
  List<ProductModel>? _cachedProducts;

  ProductRepositoryImpl({required this.localDataSource});

  Future<Result<List<ProductModel>>> _getCachedOrFetchProducts() async {
    if (_cachedProducts != null) {
      return Success(_cachedProducts!);
    }
    final result = await localDataSource.fetchProductsFromAssets();
    if (result.isSuccess) {
      _cachedProducts = result.dataOrNull;
    }
    return result;
  }

  @override
  Future<Result<List<Product>>> fetchProducts() async {
    final result = await _getCachedOrFetchProducts();
    return result.when(
      success: (products) => Success(products.map((p) => p.toEntity()).toList()),
      failure: (message) => Failure(message),
    );
  }

  @override
  Future<Result<Product>> fetchProductById(String id) async {
    final productsResult = await _getCachedOrFetchProducts();
    if (productsResult.isFailure) {
      return Failure(productsResult.errorOrNull!);
    }

    final result = await localDataSource.fetchProductById(id, productsResult.dataOrNull!);
    return result.when(
      success: (product) => Success(product.toEntity()),
      failure: (message) => Failure(message),
    );
  }

  @override
  Future<Result<List<Product>>> searchProducts(String query) async {
    final productsResult = await _getCachedOrFetchProducts();
    if (productsResult.isFailure) {
      return Failure(productsResult.errorOrNull!);
    }

    final result = await localDataSource.searchProducts(query, productsResult.dataOrNull!);
    return result.when(
      success: (products) => Success(products.map((p) => p.toEntity()).toList()),
      failure: (message) => Failure(message),
    );
  }

  @override
  Future<Result<List<Product>>> filterByCategory(String category) async {
    final productsResult = await _getCachedOrFetchProducts();
    if (productsResult.isFailure) {
      return Failure(productsResult.errorOrNull!);
    }

    final result = await localDataSource.filterByCategory(category, productsResult.dataOrNull!);
    return result.when(
      success: (products) => Success(products.map((p) => p.toEntity()).toList()),
      failure: (message) => Failure(message),
    );
  }
}
