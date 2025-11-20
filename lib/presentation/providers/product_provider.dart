import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product.dart';
import '../../core/utils/result.dart';
import 'repository_providers.dart';
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final productRepo = ref.watch(productRepositoryProvider);
  final result = await productRepo.fetchProducts();
  
  return result.when(
    success: (products) => products,
    failure: (message) => throw Exception(message),
  );
});
final productByIdProvider = FutureProvider.family<Product, String>((ref, id) async {
  final productRepo = ref.watch(productRepositoryProvider);
  final result = await productRepo.fetchProductById(id);
  
  return result.when(
    success: (product) => product,
    failure: (message) => throw Exception(message),
  );
});
final searchQueryProvider = StateProvider<String>((ref) => '');
final selectedCategoryProvider = StateProvider<String?>((ref) => null);
final filteredProductsProvider = FutureProvider<List<Product>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  final category = ref.watch(selectedCategoryProvider);
  
  final products = await ref.watch(productsProvider.future);
  
  var filtered = products;
  if (category != null && category.isNotEmpty) {
    filtered = filtered.where((p) => p.category == category).toList();
  }
  if (query.isNotEmpty) {
    final lowerQuery = query.toLowerCase();
    filtered = filtered.where((p) {
      return p.title.toLowerCase().contains(lowerQuery) ||
          p.description.toLowerCase().contains(lowerQuery) ||
          p.category.toLowerCase().contains(lowerQuery) ||
          (p.switches.toLowerCase().contains(lowerQuery)) ||
          (p.keycaps.toLowerCase().contains(lowerQuery));
    }).toList();
  }
  
  return filtered;
});
final categoriesProvider = Provider<List<String>>((ref) {
  final productsAsync = ref.watch(productsProvider);
  
  return productsAsync.when(
    data: (products) {
      final categories = products.map((p) => p.category).toSet().toList();
      categories.sort();
      return categories;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});
