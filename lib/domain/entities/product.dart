import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String title;
  final double price;
  final String category;
  final String description;
  final String thumbnail;
  final List<String> images;
  final int stock;
  final String switches;
  final String keycaps;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.description,
    required this.thumbnail,
    required this.images,
    required this.stock,
    required this.switches,
    required this.keycaps,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      description: json['description'] as String,
      thumbnail: json['thumbnail'] as String,
      images: (json['images'] as List<dynamic>).cast<String>(),
      stock: json['stock'] as int,
      switches: json['switches'] as String,
      keycaps: json['keycaps'] as String,
    );
  }

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

  Product copyWith({
    String? id,
    String? title,
    double? price,
    String? category,
    String? description,
    String? thumbnail,
    List<String>? images,
    int? stock,
    String? switches,
    String? keycaps,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      category: category ?? this.category,
      description: description ?? this.description,
      thumbnail: thumbnail ?? this.thumbnail,
      images: images ?? this.images,
      stock: stock ?? this.stock,
      switches: switches ?? this.switches,
      keycaps: keycaps ?? this.keycaps,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        price,
        category,
        description,
        thumbnail,
        images,
        stock,
        switches,
        keycaps,
      ];
}

