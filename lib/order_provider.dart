import 'package:flutter/foundation.dart'; // PERBAIKAN: Import untuk debugPrint
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_flutter/cart_item.dart';
import 'package:final_project_flutter/order_item.dart';

class OrderProvider with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String? userId;

  OrderProvider(this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    if (userId == null) return;
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('orders')
          .orderBy('dateTime', descending: true)
          .get();

      final List<OrderItem> loadedOrders = [];
      for (var doc in querySnapshot.docs) {
        loadedOrders.add(OrderItem.fromMap(doc.id, doc.data()));
      }
      _orders = loadedOrders;
      notifyListeners();
    } catch (error) {
      // PERBAIKAN: Mengganti print dengan debugPrint
      debugPrint('Error fetching orders: $error');
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    if (userId == null) return;
    final timestamp = DateTime.now();
    try {
      final docRef =
          await FirebaseFirestore.instance.collection('users').doc(userId).collection('orders').add({
        'totalAmount': total,
        'dateTime': Timestamp.fromDate(timestamp),
        'products': cartProducts
            .map((cp) => cp.toMap())
            .toList(),
      });

      final newOrder = OrderItem(
        id: docRef.id,
        totalAmount: total,
        products: cartProducts,
        dateTime: timestamp,
      );
      _orders.insert(0, newOrder);
      notifyListeners();
    } catch (error) {
      debugPrint('Error adding order: $error');
      rethrow;
    }
  }
}
