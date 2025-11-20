import 'package:equatable/equatable.dart';
import 'product.dart';

class OrderItem extends Equatable {
  final Product product;
  final int quantity;
  final double priceAtPurchase;

  const OrderItem({
    required this.product,
    required this.quantity,
    required this.priceAtPurchase,
  });

  double get subtotal => priceAtPurchase * quantity;

  Map<String, dynamic> toJson() => {
        'product': {
          'id': product.id,
          'title': product.title,
          'price': product.price,
          'thumbnail': product.thumbnail,
          'category': product.category,
        },
        'quantity': quantity,
        'priceAtPurchase': priceAtPurchase,
      };

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      product: Product(
        id: json['product']['id'],
        title: json['product']['title'],
        price: (json['product']['price'] as num).toDouble(),
        category: json['product']['category'],
        description: '',
        thumbnail: json['product']['thumbnail'],
        images: [],
        stock: 0,
        switches: '',
        keycaps: '',
      ),
      quantity: json['quantity'],
      priceAtPurchase: (json['priceAtPurchase'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [product, quantity, priceAtPurchase];
}
