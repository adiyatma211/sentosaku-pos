import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/presentation/screens/splash_screen.dart';
import 'src/presentation/screens/pos_screen.dart';
import 'src/presentation/screens/cart_screen.dart';
import 'src/presentation/screens/transaction_history_screen.dart';
import 'src/presentation/screens/category_management_screen.dart';
import 'src/presentation/screens/product_management_screen.dart';
import 'src/presentation/screens/dashboard_screen.dart';

void main() {
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sentosa POS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'JakartaSans',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/pos': (context) => const POSScreen(),
        '/cart': (context) => const CartScreen(),
        '/transaction_history': (context) => const TransactionHistoryScreen(),
        '/category_management': (context) => const CategoryManagementScreen(),
        '/product_management': (context) => const ProductManagementScreen(),
      },
    );
  }
}
