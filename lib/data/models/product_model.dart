import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.category,
    required super.description,
    required super.thumbnail,
    required super.images,
    required super.stock,
    required super.switches,
    required super.keycaps,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      description: json['description'] as String,
      thumbnail: json['thumbnail'] as String,
      images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      stock: json['stock'] as int,
      switches: json['switches'] as String,
      keycaps: json['keycaps'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'category': category,
      'description': description,
      'thumbnail': thumbnail,
      'images': images,
      'stock': stock,
      'switches': switches,
      'keycaps': keycaps,
    };
  }

  Product toEntity() {
    return Product(
      id: id,
      title: title,
      price: price,
      category: category,
      description: description,
      thumbnail: thumbnail,
      images: images,
      stock: stock,
      switches: switches,
      keycaps: keycaps,
    );
  }
}
