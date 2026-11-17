import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/cart_service.dart';

class DetailPage extends StatefulWidget {
  final Product product;
  final String username;
  const DetailPage({super.key, required this.product, required this.username});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _qty = 1; // 0 < qty <= totalQty (stock)

  Future<void> _addToCart() async {
    final p = widget.product;
    await CartService.add(widget.username, p, _qty, p.stock);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${p.title} (x$_qty) ditambahkan ke cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final outOfStock = p.stock <= 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Image.network(p.thumbnail,
                height: 220,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported, size: 100)),
          ),
          const SizedBox(height: 16),
          Text(p.title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('\$${p.price}',
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.star, size: 18, color: Colors.orange),
            Text(' ${p.rating}  |  Stok: ${p.stock}  |  ${p.category}'),
          ]),
          const Divider(height: 28),
          const Text('Deskripsi',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(p.description),
          const SizedBox(height: 24),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: _qty > 1 ? () => setState(() => _qty--) : null,
              ),
              Text('$_qty', style: const TextStyle(fontSize: 18)),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: _qty < p.stock ? () => setState(() => _qty++) : null,
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: outOfStock ? null : _addToCart,
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Add to Cart'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
