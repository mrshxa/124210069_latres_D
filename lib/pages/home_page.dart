import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import 'cart_page.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text('Hi welcome, ${widget.username}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => CartPage(username: widget.username)),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Error: ${snap.error}'),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => setState(
                        () => _future = ApiService.fetchProducts()),
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            );
          }
          final products = snap.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: products.length,
            itemBuilder: (context, i) {
              final p = products[i];
              return Card(
                child: ListTile(
                  leading: Image.network(p.thumbnail,
                      width: 48,
                      height: 48,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image_not_supported)),
                  title: Text(p.title,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text('${p.category} | \$${p.price}'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          DetailPage(product: p, username: widget.username),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
