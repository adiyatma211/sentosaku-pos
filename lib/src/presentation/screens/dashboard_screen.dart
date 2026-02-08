import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/utils/responsive_helper.dart';
import '../providers/dashboard_provider.dart';
import 'pos_screen.dart';
import 'cart_screen.dart';
import 'transaction_history_screen.dart';
import 'product_management_screen.dart';
import 'category_management_screen.dart';
import 'business_settings_screen.dart';
import 'printer_settings_screen.dart';
import '../widgets/custom_toast.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responsive = ResponsiveHelper(context);
    final dashboardStats = ref.watch(dashboardStatsProvider);
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF5F7FA),
              Color(0xFFE8F0E9),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(responsive.getResponsivePadding()),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5E8C52), Color(0xFFA1B986)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF5E8C52).withOpacity(0.25),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Welcome Back!',
                                  style: TextStyle(
                                    fontSize: responsive.getResponsiveFontSize(portraitSize: 22, landscapeSize: 24),
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              const SizedBox(height: 4),
                              Text(
                                  'Sentosa POS System',
                                  style: TextStyle(
                                    fontSize: responsive.getResponsiveFontSize(portraitSize: 13, landscapeSize: 14),
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              Icons.storefront,
                              size: responsive.getResponsiveIconSize(),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Dashboard Stats Cards
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.getResponsivePadding()),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          _buildGlassmorphismCard(
                            context,
                            icon: Icons.inventory_2_outlined,
                            title: 'Produk',
                            value: dashboardStats.when(
                              data: (stats) => stats.totalProducts.toString(),
                              loading: () => '...',
                              error: (_, __) => '0',
                            ),
                            color: const Color(0xFF5E8C52),
                            responsive: responsive,
                          ),
                          const SizedBox(width: 12),
                          _buildGlassmorphismCard(
                            context,
                            icon: Icons.receipt_long,
                            title: 'Transaksi',
                            value: dashboardStats.when(
                              data: (stats) => stats.todayTransactions.toString(),
                              loading: () => '...',
                              error: (_, __) => '0',
                            ),
                            color: const Color(0xFF5E8C52),
                            responsive: responsive,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildGlassmorphismCard(
                        context,
                        icon: Icons.payments,
                        title: 'Omzet',
                        value: dashboardStats.when(
                          data: (stats) => formatDashboardPrice(stats.todayRevenue),
                          loading: () => '...',
                          error: (_, __) => 'Rp 0',
                        ),
                        color: const Color(0xFF5E8C52),
                        responsive: responsive,
                        isFullWidth: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Recent Notes Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.getResponsivePadding()),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Nota Terbaru',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1A1A2A),
                                letterSpacing: -0.3,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TransactionHistoryScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Lihat Semua',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF5E8C52),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        dashboardStats.when(
                          data: (stats) {
                            if (stats.recentOrders.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: Center(
                                  child: Text(
                                    'Belum ada transaksi hari ini',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              );
                            }
                            return Column(
                              children: stats.recentOrders.map((order) {
                                return _buildRecentNoteCard(
                                  context,
                                  title: order.orderNumber,
                                  subtitle: 'Kasir',
                                  amount: NumberFormat.currency(
                                    locale: 'id_ID',
                                    symbol: 'Rp',
                                    decimalDigits: 0,
                                  ).format(order.totalAmount),
                                  time: DateFormat('HH:mm').format(order.orderDate),
                                  status: order.status,
                                  color: const Color(0xFF5E8C52),
                                );
                              }).toList(),
                            );
                          },
                          loading: () => const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          error: (error, _) => Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                'Gagal memuat data',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red[600],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Quick Actions Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.getResponsivePadding()),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildQuickActionButton(
                            context,
                            icon: Icons.file_download,
                            title: 'Export',
                            color: const Color(0xFF5E8C52),
                            onTap: () {
                              CustomToast.show(
                                context,
                                message: 'Export coming soon!',
                                backgroundColor: const Color(0xFF5E8C52),
                                textColor: Colors.white,
                                icon: Icons.file_download,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildQuickActionButton(
                            context,
                            icon: Icons.bar_chart,
                            title: 'Analytic',
                            color: const Color(0xFF5E8C52),
                            onTap: () {
                              // Simple chart placeholder - requires fl_chart package to be installed
                              // Run: flutter pub add fl_chart
                              CustomToast.info(
                                context,
                                'Chart requires fl_chart package. Run: flutter pub add fl_chart',
                                duration: const Duration(seconds: 3),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Menu Grid
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.getResponsivePadding()),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: responsive.getDashboardGridColumns(),
                    crossAxisSpacing: responsive.getResponsiveSpacing(),
                    mainAxisSpacing: responsive.getResponsiveSpacing(),
                    childAspectRatio: 2.5,
                    children: [
                      _buildMenuIcon(
                        context,
                        icon: Icons.point_of_sale,
                        title: 'Kasir',
                        color: const Color(0xFF5E8C52),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const POSScreen(),
                            ),
                          );
                        },
                      ),
                      _buildMenuIcon(
                        context,
                        icon: Icons.history,
                        title: 'Riwayat',
                        color: const Color(0xFF5E8C52),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const TransactionHistoryScreen(),
                            ),
                          );
                        },
                      ),
                      _buildMenuIcon(
                        context,
                        icon: Icons.inventory_2,
                        title: 'Produk',
                        color: const Color(0xFF5E8C52),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CategoryManagementScreen(),
                            ),
                          );
                        },
                      ),
                      _buildMenuIcon(
                        context,
                        icon: Icons.settings,
                        title: 'Pengaturan',
                        color: const Color(0xFF5E8C52),
                        onTap: () {
                          _showSettingsMenu(context);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Footer
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.getResponsivePadding()),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Version 1.0.0',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassmorphismCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required ResponsiveHelper responsive,
    bool isFullWidth = false,
  }) {
    return Flexible(
      child: TweenAnimationBuilder<double>(
        duration: Duration.zero,
        tween: Tween(begin: 0, end: 1),
        builder: (context, animationValue, child) {
          return Transform.scale(
            scale: 0.95 + (0.05 * animationValue),
            child: Opacity(
              opacity: animationValue,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          color.withOpacity(0.25),
                          color.withOpacity(0.12),
                          Colors.white.withOpacity(0.08),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.35),
                        width: 1.5,
                      ),
                      boxShadow: [
                        // Colored glow effect
                        BoxShadow(
                          color: color.withOpacity(0.25),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                          spreadRadius: -4,
                        ),
                        // Subtle colored glow
                        BoxShadow(
                          color: color.withOpacity(0.15),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                          spreadRadius: -2,
                        ),
                        // Deep shadow for depth
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                        // Ambient shadow
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    color,
                                    color.withOpacity(0.7),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: color.withOpacity(0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                    spreadRadius: 0,
                                  ),
                                  BoxShadow(
                                    color: color.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                icon,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: responsive.getResponsiveFontSize(portraitSize: 11, landscapeSize: 12),
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white.withOpacity(0.85),
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    value,
                                    style: TextStyle(
                                      fontSize: responsive.getResponsiveFontSize(portraitSize: 18, landscapeSize: 20),
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      letterSpacing: -0.5,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentNoteCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String amount,
    required String time,
    required String status,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.08),
            color.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color,
                  color.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.receipt,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2A),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2A),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                time,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuIcon(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.12),
              color.withOpacity(0.06),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.25),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pengaturan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2A),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              _buildSettingsMenuItem(
                icon: Icons.store,
                title: 'Informasi Bisnis',
                subtitle: 'Kelola informasi toko',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BusinessSettingsScreen(),
                    ),
                  );
                },
              ),
              _buildSettingsMenuItem(
                icon: Icons.print,
                title: 'Pengaturan Printer',
                subtitle: 'Konfigurasi printer dan cetakan',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrinterSettingsScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF5E8C52).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF5E8C52),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
