import 'dart:convert';
import 'package:flutter/services.dart';
import '../../core/utils/result.dart';
import '../models/product_model.dart';

class ProductLocalDataSource {
  Future<Result<List<ProductModel>>> fetchProductsFromAssets() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/keyboards_mock.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      final products = jsonList.map((json) => ProductModel.fromJson(json)).toList();
      return Success(products);
    } catch (e) {
      return Failure('Erreur lors du chargement des produits: ${e.toString()}');
    }
  }

  Future<Result<ProductModel>> fetchProductById(String id, List<ProductModel> products) async {
    try {
      final product = products.firstWhere((p) => p.id == id);
      return Success(product);
    } catch (e) {
      return const Failure('Produit non trouvé');
    }
  }

  Future<Result<List<ProductModel>>> searchProducts(String query, List<ProductModel> products) async {
    try {
      final lowerQuery = query.toLowerCase();
      final filtered = products.where((p) {
        return p.title.toLowerCase().contains(lowerQuery) ||
            p.category.toLowerCase().contains(lowerQuery) ||
            p.description.toLowerCase().contains(lowerQuery);
      }).toList();
      return Success(filtered);
    } catch (e) {
      return Failure('Erreur lors de la recherche: ${e.toString()}');
    }
  }

  Future<Result<List<ProductModel>>> filterByCategory(String category, List<ProductModel> products) async {
    try {
      final filtered = products.where((p) => p.category == category).toList();
      return Success(filtered);
    } catch (e) {
      return Failure('Erreur lors du filtrage: ${e.toString()}');
    }
  }
}
