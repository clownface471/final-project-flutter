import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cart_item.dart';
import 'dessert.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  CartProvider() {
    _loadCart();
  }

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
    _saveCart();
    notifyListeners();
  }

  void removeItem(String dessertId) {
    _items.remove(dessertId);
    _saveCart();
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
    _saveCart();
    notifyListeners();
  }

  void clear() {
    _items = {};
    _saveCart();
    notifyListeners();
  }

  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = _items.values.map((item) => item.toMap()).toList();
      final cartString = json.encode(cartData);
      await prefs.setString('cartItems', cartString);
    } catch (e) {
      // ignore: avoid_print
      print('Error saving cart: $e');
    }
  }

  Future<void> _loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('cartItems')) {
        return;
      }
      final cartString = prefs.getString('cartItems')!;
      final List<dynamic> cartData = json.decode(cartString);
      
      _items = {}; 
      
      for (var itemData in cartData) {
        final cartItem = CartItem.fromMap(itemData);
        _items[cartItem.dessert.id] = cartItem;
      }

      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print('Error loading cart: $e');
    }
  }
}
