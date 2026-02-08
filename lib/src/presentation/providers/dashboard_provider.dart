import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/repositories/order_repository.dart';
import '../../data/repositories/product_repository.dart';
import '../../domain/entities/order.dart' as entity;
import '../../domain/entities/product.dart' as product_entity;
import 'domain_providers.dart';

// Dashboard statistics model
class DashboardStats {
  final int totalProducts;
  final int todayTransactions;
  final int todayRevenue;
  final List<entity.Order> recentOrders;

  DashboardStats({
    required this.totalProducts,
    required this.todayTransactions,
    required this.todayRevenue,
    required this.recentOrders,
  });
}

// Dashboard stats provider
final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  final productRepository = ref.watch(productRepositoryProvider);
  final orderRepository = ref.watch(orderRepositoryProvider);

  // Fetch all active products
  final products = await productRepository.getActiveProducts();
  final totalProducts = products.length;

  // Fetch today's orders
  final todayOrders = await orderRepository.getTodayOrders();
  final todayTransactions = todayOrders.length;

  // Calculate today's revenue
  final todayRevenue = todayOrders.fold<int>(
    0,
    (sum, order) => sum + order.totalAmount,
  );

  // Get recent orders (last 5 orders)
  final recentOrders = todayOrders.take(5).toList();

  return DashboardStats(
    totalProducts: totalProducts,
    todayTransactions: todayTransactions,
    todayRevenue: todayRevenue,
    recentOrders: recentOrders,
  );
});

// Format price helper
String formatDashboardPrice(int price) {
  if (price >= 1000000) {
    // Convert to millions (Juta)
    final millions = price / 1000000;
    return 'Rp ${millions.toStringAsFixed(1)} Juta';
  } else if (price >= 1000) {
    // Convert to thousands (K)
    final thousands = price / 1000;
    return 'Rp ${thousands.toStringAsFixed(1)}K';
  } else {
    // Use standard currency format
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(price);
  }
}
