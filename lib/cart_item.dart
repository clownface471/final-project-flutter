import 'package:final_project_flutter/dessert.dart';

class CartItem {
  final Dessert dessert;
  int quantity;

  CartItem({required this.dessert, this.quantity = 1});

  double get totalPrice => dessert.price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'dessert': dessert.toMap(),
      'quantity': quantity.toDouble(),
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      dessert: Dessert.fromMap(map['dessert'] as Map<String, dynamic>),
      quantity: (map['quantity'] as num? ?? 1).round(),
    );
  }
}
