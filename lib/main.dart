import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/main_page.dart';
import 'services/cart_service.dart';
import 'services/session_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CartService.init();
  final username = await SessionService.getUsername();
  runApp(MyApp(username: username));
}

class MyApp extends StatelessWidget {
  final String? username;
  const MyApp({super.key, this.username});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Online Baru',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // Sudah login -> langsung ke halaman utama
      home: username == null ? const LoginPage() : MainPage(username: username!),
    );
  }
}
