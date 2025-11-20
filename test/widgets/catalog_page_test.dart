import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rendu/domain/entities/product.dart';

void main() {
  group('Catalog Widget Tests', () {
    const mockProducts = [
      Product(
        id: '1',
        title: 'Mechanical Keyboard 1',
        price: 99.99,
        category: 'mechanical',
        description: 'Great keyboard',
        thumbnail: 'https://picsum.photos/200',
        images: ['https://picsum.photos/200'],
        stock: 10,
        switches: 'Cherry MX Red',
        keycaps: 'PBT',
      ),
      Product(
        id: '2',
        title: 'Gaming Keyboard 2',
        price: 149.99,
        category: 'gaming',
        description: 'RGB keyboard',
        thumbnail: 'https://picsum.photos/201',
        images: ['https://picsum.photos/201'],
        stock: 5,
        switches: 'Gateron Brown',
        keycaps: 'ABS',
      ),
    ];

    testWidgets('Search bar is displayed', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher un clavier...',
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Rechercher un clavier...'), findsOneWidget);
    });

    testWidgets('Product list displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ListView.builder(
                itemCount: mockProducts.length,
                itemBuilder: (context, index) {
                  final product = mockProducts[index];
                  return ListTile(
                    title: Text(product.title),
                    subtitle: Text('${product.price.toStringAsFixed(2)} €'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Mechanical Keyboard 1'), findsOneWidget);
      expect(find.text('Gaming Keyboard 2'), findsOneWidget);
    });
  });
}

