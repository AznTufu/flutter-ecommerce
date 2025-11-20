import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_rendu/presentation/providers/cart_provider.dart';
import 'package:flutter_rendu/domain/entities/product.dart';

void main() {
  group('CartNotifier Tests', () {
    late CartNotifier cartNotifier;

    setUp(() {
      cartNotifier = CartNotifier();
    });

    test('Initial cart should be empty', () {
      expect(cartNotifier.state.items, isEmpty);
      expect(cartNotifier.state.total, 0.0);
      expect(cartNotifier.state.itemCount, 0);
    });

    test('Adding a product should increase cart items', () {
      final product = Product(
        id: '1',
        title: 'Test Keyboard',
        price: 99.99,
        category: 'Test',
        description: 'A test keyboard',
        thumbnail: 'https://example.com/image.jpg',
        images: ['https://example.com/image.jpg'],
        stock: 10,
        switches: 'Test Switch',
        keycaps: 'Test Keycaps',
      );

      cartNotifier.addToCart(product);

      expect(cartNotifier.state.items.length, 1);
      expect(cartNotifier.state.items.first.quantity, 1);
      expect(cartNotifier.state.total, 99.99);
    });

    test('Adding same product twice should increase quantity', () {
      final product = Product(
        id: '1',
        title: 'Test Keyboard',
        price: 99.99,
        category: 'Test',
        description: 'A test keyboard',
        thumbnail: 'https://example.com/image.jpg',
        images: ['https://example.com/image.jpg'],
        stock: 10,
        switches: 'Test Switch',
        keycaps: 'Test Keycaps',
      );

      cartNotifier.addToCart(product);
      cartNotifier.addToCart(product);

      expect(cartNotifier.state.items.length, 1);
      expect(cartNotifier.state.items.first.quantity, 2);
      expect(cartNotifier.state.total, 199.98);
    });

    test('Removing a product should decrease cart items', () {
      final product = Product(
        id: '1',
        title: 'Test Keyboard',
        price: 99.99,
        category: 'Test',
        description: 'A test keyboard',
        thumbnail: 'https://example.com/image.jpg',
        images: ['https://example.com/image.jpg'],
        stock: 10,
        switches: 'Test Switch',
        keycaps: 'Test Keycaps',
      );

      cartNotifier.addToCart(product);
      cartNotifier.removeFromCart('1');

      expect(cartNotifier.state.items, isEmpty);
      expect(cartNotifier.state.total, 0.0);
    });

    test('Clearing cart should remove all items', () {
      final product1 = Product(
        id: '1',
        title: 'Test Keyboard 1',
        price: 99.99,
        category: 'Test',
        description: 'A test keyboard',
        thumbnail: 'https://example.com/image.jpg',
        images: ['https://example.com/image.jpg'],
        stock: 10,
        switches: 'Test Switch',
        keycaps: 'Test Keycaps',
      );

      final product2 = Product(
        id: '2',
        title: 'Test Keyboard 2',
        price: 149.99,
        category: 'Test',
        description: 'Another test keyboard',
        thumbnail: 'https://example.com/image.jpg',
        images: ['https://example.com/image.jpg'],
        stock: 5,
        switches: 'Test Switch',
        keycaps: 'Test Keycaps',
      );

      cartNotifier.addToCart(product1);
      cartNotifier.addToCart(product2);
      cartNotifier.clearCart();

      expect(cartNotifier.state.items, isEmpty);
      expect(cartNotifier.state.total, 0.0);
    });
  });
}
