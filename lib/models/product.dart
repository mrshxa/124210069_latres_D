class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double rating;
  final int stock;
  final String thumbnail;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.rating,
    required this.stock,
    required this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> j) => Product(
        id: j['id'] as int,
        title: j['title'] ?? '',
        description: j['description'] ?? '',
        category: j['category'] ?? '',
        price: (j['price'] as num).toDouble(),
        rating: ((j['rating'] ?? 0) as num).toDouble(),
        stock: (j['stock'] ?? 0) as int,
        thumbnail: j['thumbnail'] ?? '',
      );
}

/// Item di keranjang (disimpan di Hive sebagai Map).
class CartItem {
  final int productId;
  final String title;
  final double price;
  final String thumbnail;
  final int qty;

  CartItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.thumbnail,
    required this.qty,
  });

  Map<String, dynamic> toMap() => {
        'productId': productId,
        'title': title,
        'price': price,
        'thumbnail': thumbnail,
        'qty': qty,
      };

  factory CartItem.fromMap(Map m) => CartItem(
        productId: m['productId'] as int,
        title: m['title'] as String,
        price: (m['price'] as num).toDouble(),
        thumbnail: m['thumbnail'] as String,
        qty: m['qty'] as int,
      );
}
