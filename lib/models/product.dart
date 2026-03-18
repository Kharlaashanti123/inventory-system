class Product {
  String id;
  String name;
  String description;
  double price;
  int quantity;
  String categoryId;
  String supplierId;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.categoryId,
    required this.supplierId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'categoryId': categoryId,
      'supplierId': supplierId,
    };
  }

  factory Product.fromMap(String id, Map<String, dynamic> map) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 0,
      categoryId: map['categoryId'] ?? '',
      supplierId: map['supplierId'] ?? '',
    );
  }
}