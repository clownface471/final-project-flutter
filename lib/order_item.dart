import 'package:final_project_flutter/cart_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String id;
  final double totalAmount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.totalAmount,
    required this.products,
    required this.dateTime,
  });

  factory OrderItem.fromMap(String id, Map<String, dynamic> data) {
    
    double safeGetDouble(dynamic value) {
      if (value is int) {
        return value.toDouble();
      } else if (value is double) {
        return value;
      } else {
        return 0.0; 
      }
    }

    return OrderItem(
      id: id,
      totalAmount: safeGetDouble(data['totalAmount']),
      products: (data['products'] as List<dynamic>)
          .map((item) => CartItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      dateTime: (data['dateTime'] as Timestamp).toDate(),
    );
  }
}

