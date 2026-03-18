class Supplier {
  String id;
  String name;
  String contact;
  String email;
  String address;

  Supplier({
    required this.id,
    required this.name,
    required this.contact,
    required this.email,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'contact': contact,
      'email': email,
      'address': address,
    };
  }

  factory Supplier.fromMap(String id, Map<String, dynamic> map) {
    return Supplier(
      id: id,
      name: map['name'] ?? '',
      contact: map['contact'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
    );
  }
}