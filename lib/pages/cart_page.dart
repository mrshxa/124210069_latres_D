import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/product.dart';
import '../services/cart_service.dart';

class CartPage extends StatelessWidget {
  final String username;
  const CartPage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      // Rebuild otomatis saat isi box Hive berubah
      body: ValueListenableBuilder(
        valueListenable: Hive.box(CartService.boxName).listenable(),
        builder: (context, _, __) {
          final items = CartService.itemsOf(username);
          final total =
              items.fold<double>(0, (s, e) => s + e.price * e.qty);
          return Column(
            children: [
              Expanded(
                child: items.isEmpty
                    ? const Center(child: Text('Keranjang kosong'))
                    : ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, i) => _tile(items[i]),
                      ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('\$${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _tile(CartItem it) {
    return Card(
      child: ListTile(
        leading: Image.network(it.thumbnail,
            width: 48,
            height: 48,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.image_not_supported)),
        title: Text(it.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
            'Qty: ${it.qty} | Harga: \$${(it.price * it.qty).toStringAsFixed(2)}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => CartService.remove(username, it.productId),
        ),
      ),
    );
  }
}
