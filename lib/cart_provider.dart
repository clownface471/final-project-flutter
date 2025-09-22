import 'package:flutter/foundation.dart';
import 'cart_item.dart';
import 'dessert.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.totalPrice;
    });
    return total;
  }

  void addItem(Dessert dessert) {
    if (_items.containsKey(dessert.id)) {
      _items.update(
        dessert.id,
        (existingCartItem) => CartItem(
          dessert: existingCartItem.dessert,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        dessert.id,
        () => CartItem(
          dessert: dessert,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String dessertId) {
    _items.remove(dessertId);
    notifyListeners();
  }

  void removeSingleItem(String dessertId) {
    if (!_items.containsKey(dessertId)) {
      return;
    }
    if (_items[dessertId]!.quantity > 1) {
      _items.update(
        dessertId,
        (existingCartItem) => CartItem(
          dessert: existingCartItem.dessert,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(dessertId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}

