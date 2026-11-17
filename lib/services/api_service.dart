import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/product.dart';

class ApiService {
  static Future<List<Product>> fetchProducts() async {
    final res = await http.get(Uri.parse('$kProductsUrl?limit=100'));
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat produk (${res.statusCode})');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return (data['products'] as List)
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
