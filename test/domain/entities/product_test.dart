import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_rendu/domain/entities/product.dart';

void main() {
  group('Product Entity Tests', () {
    const testProduct = Product(
      id: '1',
      title: 'Test Keyboard',
      price: 99.99,
      category: 'mechanical',
      description: 'Test description',
      thumbnail: 'https://picsum.photos/200',
      images: ['https://picsum.photos/200', 'https://picsum.photos/201'],
      stock: 10,
      switches: 'Cherry MX Red',
      keycaps: 'PBT Double Shot',
    );

    test('Product fromJson creates correct instance', () {
      final json = {
        'id': '1',
        'title': 'Test Keyboard',
        'price': 99.99,
        'category': 'mechanical',
        'description': 'Test description',
        'thumbnail': 'https://picsum.photos/200',
        'images': ['https://picsum.photos/200', 'https://picsum.photos/201'],
        'stock': 10,
        'switches': 'Cherry MX Red',
        'keycaps': 'PBT Double Shot',
      };

      final product = Product.fromJson(json);

      expect(product.id, '1');
      expect(product.title, 'Test Keyboard');
      expect(product.price, 99.99);
      expect(product.category, 'mechanical');
      expect(product.description, 'Test description');
      expect(product.thumbnail, 'https://picsum.photos/200');
      expect(product.images.length, 2);
      expect(product.stock, 10);
      expect(product.switches, 'Cherry MX Red');
      expect(product.keycaps, 'PBT Double Shot');
    });

    test('Product toJson creates correct map', () {
      final json = testProduct.toJson();

      expect(json['id'], '1');
      expect(json['title'], 'Test Keyboard');
      expect(json['price'], 99.99);
      expect(json['category'], 'mechanical');
      expect(json['description'], 'Test description');
      expect(json['thumbnail'], 'https://picsum.photos/200');
      expect(json['images'], ['https://picsum.photos/200', 'https://picsum.photos/201']);
      expect(json['stock'], 10);
      expect(json['switches'], 'Cherry MX Red');
      expect(json['keycaps'], 'PBT Double Shot');
    });

    test('Product fromJson and toJson are reversible', () {
      final json = testProduct.toJson();
      final deserializedProduct = Product.fromJson(json);
      final reserializedJson = deserializedProduct.toJson();

      expect(reserializedJson, json);
    });

    test('Product copyWith works correctly', () {
      final updatedProduct = testProduct.copyWith(
        title: 'Updated Keyboard',
        price: 149.99,
      );

      expect(updatedProduct.id, testProduct.id);
      expect(updatedProduct.title, 'Updated Keyboard');
      expect(updatedProduct.price, 149.99);
      expect(updatedProduct.category, testProduct.category);
      expect(updatedProduct.stock, testProduct.stock);
    });

    test('Product equality works correctly', () {
      const product1 = Product(
        id: '1',
        title: 'Keyboard A',
        price: 100.0,
        category: 'mechanical',
        description: 'Desc',
        thumbnail: 'thumb',
        images: ['img1'],
        stock: 10,
        switches: 'Cherry MX',
        keycaps: 'PBT',
      );

      const product2 = Product(
        id: '1',
        title: 'Keyboard A',
        price: 100.0,
        category: 'mechanical',
        description: 'Desc',
        thumbnail: 'thumb',
        images: ['img1'],
        stock: 10,
        switches: 'Cherry MX',
        keycaps: 'PBT',
      );

      const product3 = Product(
        id: '2',
        title: 'Keyboard B',
        price: 200.0,
        category: 'gaming',
        description: 'Desc2',
        thumbnail: 'thumb2',
        images: ['img2'],
        stock: 5,
        switches: 'Gateron',
        keycaps: 'ABS',
      );

      expect(product1, product2);
      expect(product1 == product3, false);
      expect(product1.hashCode, product2.hashCode);
    });
  });
}

