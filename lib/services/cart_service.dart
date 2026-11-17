import 'package:hive_flutter/hive_flutter.dart';
import '../models/product.dart';

/// Cart disimpan di Hive. Key = "<username>_<productId>"
/// sehingga tiap user punya cart sendiri.
class CartService {
  static const boxName = 'cart';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  static Box get _box => Hive.box(boxName);

  static String _key(String user, int productId) => '${user}_$productId';

  /// Tambah ke cart. Jika sudah ada, qty ditambah (maksimal [maxQty]).
  static Future<void> add(
      String user, Product p, int qty, int maxQty) async {
    final key = _key(user, p.id);
    int total = qty;
    final existing = _box.get(key);
    if (existing != null) {
      total += CartItem.fromMap(Map.from(existing)).qty;
    }
    if (total > maxQty) total = maxQty;
    await _box.put(
      key,
      CartItem(
        productId: p.id,
        title: p.title,
        price: p.price,
        thumbnail: p.thumbnail,
        qty: total,
      ).toMap(),
    );
  }

  static List<CartItem> itemsOf(String user) {
    final prefix = '${user}_';
    return _box.keys
        .where((k) => k.toString().startsWith(prefix))
        .map((k) => CartItem.fromMap(Map.from(_box.get(k))))
        .toList();
  }

  static Future<void> remove(String user, int productId) =>
      _box.delete(_key(user, productId));
}
