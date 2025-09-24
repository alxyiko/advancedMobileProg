class Product {
  final int? id;
  final String name;
  final double price;
  final int quantity;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  // Convert object to Map (useful for JSON / databases)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }

  // Create object from Map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      quantity: map['quantity'] as int,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      quantity: json['quantity'] as int,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }

  // Optional: convert to JSON string
  // String toJson() => toMap().toString();

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }
}
