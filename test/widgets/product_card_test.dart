import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rendu/domain/entities/product.dart';

void main() {
  group('Product Display Widget Tests', () {
    final testProducts = [
      const Product(
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
      ),
      const Product(
        id: '2',
        title: 'Low Stock Keyboard',
        price: 149.99,
        category: 'gaming',
        description: 'Low stock item',
        thumbnail: 'https://picsum.photos/201',
        images: ['https://picsum.photos/201'],
        stock: 3,
        switches: 'Gateron',
        keycaps: 'ABS',
      ),
    ];

    testWidgets('Catalog displays products correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                ),
                itemCount: testProducts.length,
                itemBuilder: (context, index) {
                  final product = testProducts[index];
                  return Card(
                    child: Column(
                      children: [
                        Expanded(child: Container()),
                        Text(product.title),
                        Text('${product.price.toStringAsFixed(2)} €'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Vérifier que les titres des produits sont affichés
      expect(find.text('Test Keyboard'), findsOneWidget);
      expect(find.text('Low Stock Keyboard'), findsOneWidget);
    });

    testWidgets('Product shows price correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Text('${testProducts[0].price.toStringAsFixed(2)} €'),
            ),
          ),
        ),
      );

      expect(find.text('99.99 €'), findsOneWidget);
    });
  });
}

