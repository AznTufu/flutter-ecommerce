import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_rendu/domain/entities/order.dart';
import 'package:flutter_rendu/domain/entities/order_item.dart';
import 'package:flutter_rendu/domain/entities/product.dart';

void main() {
  group('Order Entity Tests', () {
    const testProduct = Product(
      id: '1',
      title: 'Test Keyboard',
      price: 99.99,
      category: 'mechanical',
      description: 'Test keyboard',
      thumbnail: 'https://picsum.photos/200',
      images: ['https://picsum.photos/200'],
      stock: 10,
      switches: 'Cherry MX',
      keycaps: 'PBT',
    );

    final testOrderItem = OrderItem(
      product: testProduct,
      quantity: 2,
      priceAtPurchase: 99.99,
    );

    final testOrder = Order(
      id: 'order-1',
      userId: 'user-123',
      items: [testOrderItem],
      totalAmount: 199.98,
      status: OrderStatus.pending,
      createdAt: DateTime(2024, 1, 15, 10, 30),
      shippingAddress: '123 Main St',
      shippingCity: 'Paris',
      shippingPostalCode: '75001',
      shippingName: 'John Doe',
    );

    test('Order fromJson creates correct instance', () {
      final json = {
        'id': 'order-1',
        'userId': 'user-123',
        'items': [testOrderItem.toJson()],
        'totalAmount': 199.98,
        'status': 'pending',
        'createdAt': '2024-01-15T10:30:00.000',
        'shippingAddress': '123 Main St',
        'shippingCity': 'Paris',
        'shippingPostalCode': '75001',
        'shippingName': 'John Doe',
      };

      final order = Order.fromJson(json);

      expect(order.id, 'order-1');
      expect(order.userId, 'user-123');
      expect(order.items.length, 1);
      expect(order.totalAmount, 199.98);
      expect(order.status, OrderStatus.pending);
      expect(order.createdAt, DateTime(2024, 1, 15, 10, 30));
      expect(order.shippingAddress, '123 Main St');
      expect(order.shippingCity, 'Paris');
      expect(order.shippingPostalCode, '75001');
      expect(order.shippingName, 'John Doe');
    });

    test('Order toJson creates correct map', () {
      final json = testOrder.toJson();

      expect(json['id'], 'order-1');
      expect(json['userId'], 'user-123');
      expect(json['items'], isA<List>());
      expect(json['totalAmount'], 199.98);
      expect(json['status'], 'pending');
      expect(json['createdAt'], '2024-01-15T10:30:00.000');
      expect(json['shippingAddress'], '123 Main St');
      expect(json['shippingCity'], 'Paris');
      expect(json['shippingPostalCode'], '75001');
      expect(json['shippingName'], 'John Doe');
    });

    test('OrderStatus extension displayName works correctly', () {
      expect(OrderStatus.pending.displayName, 'En attente');
      expect(OrderStatus.confirmed.displayName, 'Confirmée');
      expect(OrderStatus.shipped.displayName, 'Expédiée');
      expect(OrderStatus.delivered.displayName, 'Livrée');
      expect(OrderStatus.cancelled.displayName, 'Annulée');
    });

    test('OrderStatus fromString works correctly', () {
      expect(OrderStatusExtension.fromString('pending'), OrderStatus.pending);
      expect(OrderStatusExtension.fromString('confirmed'), OrderStatus.confirmed);
      expect(OrderStatusExtension.fromString('shipped'), OrderStatus.shipped);
      expect(OrderStatusExtension.fromString('delivered'), OrderStatus.delivered);
      expect(OrderStatusExtension.fromString('cancelled'), OrderStatus.cancelled);
      expect(OrderStatusExtension.fromString('invalid'), OrderStatus.pending);
    });

    test('Order with multiple items calculates total correctly', () {
      final item1 = OrderItem(
        product: testProduct,
        quantity: 2,
        priceAtPurchase: 99.99,
      );

      final item2 = OrderItem(
        product: testProduct.copyWith(id: '2', title: 'Keyboard 2'),
        quantity: 1,
        priceAtPurchase: 149.99,
      );

      final order = Order(
        id: 'order-2',
        userId: 'user-456',
        items: [item1, item2],
        totalAmount: 349.97, // 2*99.99 + 1*149.99
        status: OrderStatus.confirmed,
        createdAt: DateTime.now(),
        shippingAddress: '456 Oak Ave',
        shippingCity: 'Lyon',
        shippingPostalCode: '69001',
        shippingName: 'Jane Smith',
      );

      expect(order.items.length, 2);
      expect(order.totalAmount, 349.97);
    });

    test('Order copyWith works correctly', () {
      final updatedOrder = testOrder.copyWith(
        status: OrderStatus.shipped,
        shippingAddress: '789 New Street',
      );

      expect(updatedOrder.id, testOrder.id);
      expect(updatedOrder.userId, testOrder.userId);
      expect(updatedOrder.status, OrderStatus.shipped);
      expect(updatedOrder.shippingAddress, '789 New Street');
      expect(updatedOrder.shippingCity, testOrder.shippingCity);
    });
  });

  group('OrderItem Entity Tests', () {
    const testProduct = Product(
      id: '1',
      title: 'Gaming Keyboard',
      price: 129.99,
      category: 'gaming',
      description: 'RGB keyboard',
      thumbnail: 'https://picsum.photos/300',
      images: ['https://picsum.photos/300'],
      stock: 15,
      switches: 'Gateron',
      keycaps: 'ABS',
    );

    final testOrderItem = OrderItem(
      product: testProduct,
      quantity: 3,
      priceAtPurchase: 129.99,
    );

    test('OrderItem toJson creates correct map', () {
      final json = testOrderItem.toJson();

      expect(json['product'], isA<Map>());
      expect(json['quantity'], 3);
      expect(json['priceAtPurchase'], 129.99);
    });

    test('OrderItem fromJson creates correct instance', () {
      final json = {
        'product': testProduct.toJson(),
        'quantity': 3,
        'priceAtPurchase': 129.99,
      };

      final orderItem = OrderItem.fromJson(json);

      expect(orderItem.product.id, '1');
      expect(orderItem.product.title, 'Gaming Keyboard');
      expect(orderItem.quantity, 3);
      expect(orderItem.priceAtPurchase, 129.99);
    });

    test('OrderItem calculates subtotal correctly', () {
      expect(testOrderItem.quantity * testOrderItem.priceAtPurchase, 389.97);
    });
  });
}
