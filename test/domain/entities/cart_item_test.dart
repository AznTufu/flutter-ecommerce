import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_rendu/domain/entities/cart_item.dart';
import 'package:flutter_rendu/domain/entities/product.dart';

void main() {
  group('CartItem Entity Tests', () {
    const testProduct = Product(
      id: '1',
      title: 'Test Keyboard',
      price: 99.99,
      category: 'mechanical',
      description: 'Test description',
      thumbnail: 'https://picsum.photos/200',
      images: ['https://picsum.photos/200'],
      stock: 10,
      switches: 'Cherry MX',
      keycaps: 'PBT',
    );

    const testCartItem = CartItem(
      product: testProduct,
      quantity: 2,
    );

    test('CartItem is created with correct properties', () {
      expect(testCartItem.product, testProduct);
      expect(testCartItem.quantity, 2);
    });

    test('CartItem copyWith updates quantity correctly', () {
      final updated = testCartItem.copyWith(quantity: 5);

      expect(updated.product, testProduct);
      expect(updated.quantity, 5);
      expect(testCartItem.quantity, 2); // Original unchanged
    });

    test('CartItem copyWith preserves original when no changes', () {
      final same = testCartItem.copyWith();

      expect(same.product, testCartItem.product);
      expect(same.quantity, testCartItem.quantity);
    });

    test('CartItem calculates subtotal correctly', () {
      const item1 = CartItem(product: testProduct, quantity: 1);
      const item3 = CartItem(product: testProduct, quantity: 3);

      expect(item1.totalPrice, 99.99);
      expect(item3.totalPrice.toStringAsFixed(2), '299.97');
    });

    test('CartItem with different products are not equal', () {
      const product2 = Product(
        id: '2',
        title: 'Another Keyboard',
        price: 149.99,
        category: 'gaming',
        description: 'Gaming keyboard',
        thumbnail: 'https://picsum.photos/201',
        images: ['https://picsum.photos/201'],
        stock: 5,
        switches: 'Gateron',
        keycaps: 'ABS',
      );

      const cartItem2 = CartItem(product: product2, quantity: 2);

      expect(testCartItem == cartItem2, false);
    });

    test('CartItem with same product and quantity are equal', () {
      const cartItem1 = CartItem(product: testProduct, quantity: 2);
      const cartItem2 = CartItem(product: testProduct, quantity: 2);

      expect(cartItem1, cartItem2);
      expect(cartItem1.hashCode, cartItem2.hashCode);
    });

    test('CartItem props include product id and quantity', () {
      expect(testCartItem.props, [testProduct.id, 2]);
    });
  });
}
