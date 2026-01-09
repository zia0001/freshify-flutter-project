class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String image; // asset path or network URL

  Product({required this.id, required this.name, required this.category, required this.price, required this.image});

  factory Product.fromMap(Map<String, dynamic> m) => Product(
    id: m['id'] as String,
    name: m['name'] as String,
    category: m['category'] as String,
    price: (m['price'] as num).toDouble(),
    image: m['image'] as String,
  );
}
