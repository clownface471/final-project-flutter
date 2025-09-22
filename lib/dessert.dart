import 'dart:math';

class Dessert {
  final String id;
  final String name;
  final String imageUrl;
  final double price;

  Dessert({
    required this.id,
    required this.name,
    required this.imageUrl,
  }) : price = 20000.0 + Random().nextInt(30000); 

  factory Dessert.fromJson(Map<String, dynamic> json) {
    return Dessert(
      id: json['idMeal'],
      name: json['strMeal'],
      imageUrl: json['strMealThumb'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
    };
  }

  factory Dessert.fromMap(Map<String, dynamic> map) {
    return Dessert(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
    );
  }
}

