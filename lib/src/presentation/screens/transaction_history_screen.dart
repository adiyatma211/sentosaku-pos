import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/order.dart' as order_entity;
import '../../domain/entities/business_settings.dart';
import '../../core/utils/responsive_helper.dart';
import '../providers/domain_providers.dart';
import '../providers/business_settings_provider.dart';
import '../widgets/custom_toast.dart';

/// Transaction History Screen
/// Displays all transactions with search, filter, and receipt sharing/printing functionality
class TransactionHistoryScreen extends ConsumerStatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  ConsumerState<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends ConsumerState<TransactionHistoryScreen> {
  // State variables
  List<order_entity.Order> _orders = [];
  List<order_entity.Order> _filteredOrders = [];
  String _searchQuery = '';
  String _selectedStatus = 'all';
  DateTimeRange? _selectedDateRange;
  
  // UI State
  bool _isLoading = true;
  String? _errorMessage;
  
  // Controllers
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Load orders from database
  Future<void> _loadOrders() async {
    print('DEBUG TRANSACTION HISTORY: _loadOrders() START');
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('DEBUG TRANSACTION HISTORY: Fetching orders from database...');
      final orderRepository = ref.read(orderRepositoryProvider);
      final orders = await orderRepository.getAllOrders();
      print('DEBUG TRANSACTION HISTORY: Orders fetched - Count: ${orders.length}');
      
      for (final order in orders) {
        print('DEBUG TRANSACTION HISTORY: Order - ID: ${order.id}, UUID: ${order.uuid}, Order Number: ${order.orderNumber}, Status: ${order.status}, Date: ${order.orderDate}');
      }
      
      // Sort orders by date (newest first)
      orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      
      setState(() {
        _orders = orders;
        _filteredOrders = orders;
        _isLoading = false;
      });
      print('DEBUG TRANSACTION HISTORY: Orders loaded and sorted - Total: ${orders.length}');
    } catch (e) {
      print('DEBUG TRANSACTION HISTORY: ERROR - Failed to load transactions: $e');
      setState(() {
        _errorMessage = 'Failed to load transactions: $e';
        _isLoading = false;
      });
    }
    print('DEBUG TRANSACTION HISTORY: _loadOrders() END');
  }

  /// Filter orders based on search query, status, and date range
  void _filterOrders() {
    List<order_entity.Order> filtered = List.from(_orders);
    
    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((order) {
        return order.orderNumber.toLowerCase().contains(query) ||
               (order.customerName?.toLowerCase().contains(query) ?? false) ||
               (order.customerPhone?.contains(query) ?? false);
      }).toList();
    }
    
    // Filter by status
    if (_selectedStatus != 'all') {
      filtered = filtered.where((order) => order.status == _selectedStatus).toList();
    }
    
    // Filter by date range
    if (_selectedDateRange != null) {
      filtered = filtered.where((order) {
        return order.orderDate.isAfter(_selectedDateRange!.start.subtract(const Duration(days: 1))) &&
               order.orderDate.isBefore(_selectedDateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }
    
    setState(() {
      _filteredOrders = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Transaction History',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF5E8C52),
        elevation: 0,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadOrders,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          _buildSearchAndFilterSection(responsive),
          
          // Summary Section
          _buildSummarySection(responsive),
          
          // Transaction List
          Expanded(
            child: _isLoading
                ? _buildLoadingWidget()
                : _errorMessage != null
                    ? _buildErrorWidget()
                    : _filteredOrders.isEmpty
                        ? _buildEmptyWidget()
                        : _buildTransactionList(responsive),
          ),
        ],
      ),
    );
  }

  /// Build search and filter section
  Widget _buildSearchAndFilterSection(ResponsiveHelper responsive) {
    final padding = responsive.getResponsivePadding(
      portraitPadding: 12,
      landscapePadding: 16,
    );
    
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
              _filterOrders();
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF5F7FA),
              hintText: 'Search by order number or customer...',
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: Color(0xFF5E8C52),
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: Color(0xFF5E8C52),
                      ),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                        _filterOrders();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: const Color(0xFF5E8C52).withOpacity(0.15),
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: const Color(0xFF5E8C52).withOpacity(0.15),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF5E8C52),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Filter Chips
          Row(
            children: [
              // Status Filter
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF5E8C52).withOpacity(0.05),
                        const Color(0xFFA1B986).withOpacity(0.03),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF5E8C52).withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedStatus,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF5E8C52),
                      ),
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      elevation: 8,
                      style: const TextStyle(
                        color: Color(0xFF1A1A2A),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('All Status')),
                        DropdownMenuItem(value: 'paid', child: Text('Paid')),
                        DropdownMenuItem(value: 'pending', child: Text('Pending')),
                        DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
                        DropdownMenuItem(value: 'refunded', child: Text('Refunded')),
                      ],
                      onChanged: (String? value) {
                        setState(() {
                          _selectedStatus = value!;
                        });
                        _filterOrders();
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Date Filter Button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _selectDateRange,
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: Text(
                    _selectedDateRange == null
                        ? 'Date Range'
                        : '${DateFormat('MMM dd').format(_selectedDateRange!.start)} - ${DateFormat('MMM dd').format(_selectedDateRange!.end)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF5E8C52),
                    side: BorderSide(
                      color: const Color(0xFF5E8C52).withOpacity(0.3),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build summary section
  Widget _buildSummarySection(ResponsiveHelper responsive) {
    final padding = responsive.getResponsivePadding(
      portraitPadding: 12,
      landscapePadding: 16,
    );
    
    final totalTransactions = _filteredOrders.length;
    final totalRevenue = _filteredOrders.fold<int>(0, (sum, order) => sum + order.totalAmount);
    final avgTransaction = totalTransactions > 0 ? totalRevenue ~/ totalTransactions : 0;
    
    return Container(
      margin: EdgeInsets.all(padding),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5E8C52), Color(0xFFA1B986)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5E8C52).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem('Total Transactions', '$totalTransactions'),
          _buildSummaryItem('Total Revenue', _formatPrice(totalRevenue)),
          _buildSummaryItem('Avg. Transaction', _formatPrice(avgTransaction)),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Build loading widget
  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Color(0xFF5E8C52),
          ),
          SizedBox(height: 16),
          Text(
            'Loading transactions...',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  /// Build error widget
  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage ?? 'An error occurred',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loadOrders,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5E8C52),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build empty widget
  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF5E8C52).withOpacity(0.1),
                  const Color(0xFFA1B986).withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Color(0xFF5E8C52),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty || _selectedStatus != 'all' || _selectedDateRange != null
                ? 'No transactions found'
                : 'No transactions yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty || _selectedStatus != 'all' || _selectedDateRange != null
                ? 'Try adjusting your filters'
                : 'Start processing transactions to see them here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  /// Build transaction list
  Widget _buildTransactionList(ResponsiveHelper responsive) {
    final padding = responsive.getResponsivePadding(
      portraitPadding: 12,
      landscapePadding: 16,
    );
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: _filteredOrders.length,
        itemBuilder: (context, index) {
          final order = _filteredOrders[index];
          return _buildTransactionCard(order, responsive);
        },
      ),
    );
  }

  /// Build transaction card
  Widget _buildTransactionCard(order_entity.Order order, ResponsiveHelper responsive) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Colors.white,
            const Color(0xFF5E8C52).withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5E8C52).withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF5E8C52).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _showTransactionDetails(order),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Order Number
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF5E8C52), Color(0xFFA1B986)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      order.orderNumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  // Total Amount
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5E8C52).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _formatPrice(order.totalAmount),
                      style: const TextStyle(
                        color: Color(0xFF5E8C52),
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Date and Time
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5E8C52).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.access_time,
                      size: 16,
                      color: Color(0xFF5E8C52),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDateTime(order.orderDate),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Customer and Status Row
              Row(
                children: [
                  // Customer
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5E8C52).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 16,
                            color: Color(0xFF5E8C52),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            order.customerName ?? 'Guest',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusText(order.status),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              
              // Payment Method
              if (order.paymentMethod != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFA1B986).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getPaymentMethodIcon(order.paymentMethod!),
                        size: 16,
                        color: const Color(0xFF5E8C52),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getPaymentMethodText(order.paymentMethod!),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Show transaction details dialog
  void _showTransactionDetails(order_entity.Order order) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 500,
            maxHeight: 700,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [
                Colors.white,
                const Color(0xFF5E8C52).withOpacity(0.02),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5E8C52), Color(0xFFA1B986)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.receipt_long,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.orderNumber,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              _formatDateTime(order.orderDate),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status and Payment Method
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getStatusColor(order.status),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getStatusText(order.status),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (order.paymentMethod != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF5E8C52).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _getPaymentMethodIcon(order.paymentMethod!),
                                    size: 14,
                                    color: const Color(0xFF5E8C52),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _getPaymentMethodText(order.paymentMethod!),
                                    style: const TextStyle(
                                      color: Color(0xFF5E8C52),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Customer Info
                      if (order.customerName != null || order.customerPhone != null) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F7FA),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Customer',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Color(0xFF1A1A2A),
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (order.customerName != null)
                                Row(
                                  children: [
                                    const Icon(Icons.person, size: 16, color: Color(0xFF5E8C52)),
                                    const SizedBox(width: 8),
                                    Text(
                                      order.customerName!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF666666),
                                      ),
                                    ),
                                  ],
                                ),
                              if (order.customerPhone != null) ...[
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.phone, size: 16, color: Color(0xFF5E8C52)),
                                    const SizedBox(width: 8),
                                    Text(
                                      order.customerPhone!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF666666),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      
                      // Items
                      const Text(
                        'Items',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Color(0xFF1A1A2A),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F7FA),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            _buildDetailSummaryRow('Subtotal', _formatPrice(order.subtotal)),
                            _buildDetailSummaryRow('Tax', _formatPrice(order.taxAmount)),
                            _buildDetailSummaryRow(
                              'Discount',
                              _formatPrice(order.discountAmount),
                              isDiscount: true,
                            ),
                            const Divider(height: 1),
                            _buildDetailSummaryRow(
                              'Total',
                              _formatPrice(order.totalAmount),
                              isTotal: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Payment Info
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5E8C52).withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Payment Information',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Color(0xFF1A1A2A),
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildDetailRow('Paid', _formatPrice(order.paidAmount)),
                            _buildDetailRow('Change', _formatPrice(order.changeAmount)),
                          ],
                        ),
                      ),
                      
                      // Notes
                      if (order.notes != null && order.notes!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B6B).withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Notes',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Color(0xFF1A1A2A),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                order.notes!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              // Action Buttons
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FA),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    // Share Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _shareReceipt(order);
                        },
                        icon: const Icon(Icons.share_rounded, size: 20),
                        label: const Text('Share'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5E8C52),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Print Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _printReceipt(order);
                        },
                        icon: const Icon(Icons.print_rounded, size: 20),
                        label: const Text('Print'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF5E8C52),
                          elevation: 0,
                          side: const BorderSide(
                            color: Color(0xFF5E8C52),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Delete Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _showDeleteConfirmation(order);
                        },
                        icon: const Icon(Icons.delete_rounded, size: 20),
                        label: const Text('Delete'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B6B),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSummaryRow(String label, String value, {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
              color: isTotal ? const Color(0xFF1A1A2A) : Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
              color: isDiscount ? const Color(0xFFFF6B6B) : (isTotal ? const Color(0xFF5E8C52) : const Color(0xFF1A1A2A)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF666666),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2A),
            ),
          ),
        ],
      ),
    );
  }

  /// Show delete confirmation dialog
  void _showDeleteConfirmation(order_entity.Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B6B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.warning_rounded,
                color: Color(0xFFFF6B6B),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Delete Transaction?',
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to delete transaction ${order.orderNumber}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteOrder(order);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  /// Delete order
  Future<void> _deleteOrder(order_entity.Order order) async {
    try {
      final orderRepository = ref.read(orderRepositoryProvider);
      await orderRepository.softDeleteOrder(order.id);
      
      CustomToast.show(
        context,
        message: 'Transaction deleted successfully',
        backgroundColor: const Color(0xFF5E8C52),
        textColor: Colors.white,
        icon: Icons.check_circle_outline,
      );
      
      // Reload orders
      await _loadOrders();
    } catch (e) {
      CustomToast.show(
        context,
        message: 'Failed to delete transaction: ${e.toString()}',
        backgroundColor: const Color(0xFFFF6B6B),
        textColor: Colors.white,
        icon: Icons.error_outline,
      );
    }
  }

  /// Share receipt
  Future<void> _shareReceipt(order_entity.Order order) async {
    try {
      // Ensure business settings are loaded
      final businessSettingsState = ref.read(businessSettingsProvider);
      if (businessSettingsState.settings.isEmpty && !businessSettingsState.isLoading) {
        await ref.read(businessSettingsProvider.notifier).loadBusinessSettings();
      }
      final businessSettings = ref.read(businessSettingsProvider).settings.firstOrNull;
      
      // Generate PDF
      final pdfFile = await _generateReceiptPdf(order, businessSettings);
      
      // Share via WhatsApp
      await _shareViaWhatsApp(pdfFile);
      
      CustomToast.show(
        context,
        message: 'Receipt shared successfully',
        backgroundColor: const Color(0xFF5E8C52),
        textColor: Colors.white,
        icon: Icons.check_circle_outline,
      );
    } catch (e) {
      CustomToast.show(
        context,
        message: 'Failed to share receipt: ${e.toString()}',
        backgroundColor: const Color(0xFFFF6B6B),
        textColor: Colors.white,
        icon: Icons.error_outline,
      );
    }
  }

  /// Generate PDF from receipt
  Future<File> _generateReceiptPdf(order_entity.Order order, BusinessSettings? businessSettings) async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Header
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: 2),
                ),
                child: pw.Column(
                  children: [
                    pw.Text(
                      businessSettings != null ? businessSettings.storeName.toUpperCase() : 'SENTOSA POS',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Receipt',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 24),
              
              // Business Info
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300, width: 1),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      businessSettings != null ? businessSettings.storeName : 'Sentosa Cafe',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(businessSettings != null ? businessSettings.address : '123 Main Street, Jakarta'),
                    pw.Text(businessSettings != null ? 'Phone: ${businessSettings.phoneNumber}' : 'Phone: +62 812 3456'),
                  ],
                ),
              ),
              pw.SizedBox(height: 24),
              
              // Order Info
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Order #:',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(order.orderNumber),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Date:',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(_formatDate(order.orderDate)),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Time:',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(_formatTime(order.orderDate)),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 24),
              
              // Totals
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: 2),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Subtotal:'),
                        pw.Text(_formatPrice(order.subtotal)),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Tax (10%):'),
                        pw.Text(_formatPrice(order.taxAmount)),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Discount:'),
                        pw.Text(_formatPrice(order.discountAmount)),
                      ],
                    ),
                    pw.Divider(),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Total:',
                          style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          _formatPrice(order.totalAmount),
                          style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 24),
              
              // Payment Info
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Payment Information',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Payment Method:'),
                        pw.Text(order.paymentMethod?.toUpperCase() ?? 'CASH'),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Paid:'),
                        pw.Text(_formatPrice(order.paidAmount)),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Change:'),
                        pw.Text(_formatPrice(order.changeAmount)),
                      ],
                    ),
                  ],
                ),
              ),
              pw.Spacer(),
              
              // Footer
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: 2),
                ),
                child: pw.Column(
                  children: [
                    pw.Text(
                      'Thank you for your purchase!',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text('Please come again soon.'),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
    
    // Save PDF to file
    final output = await getApplicationDocumentsDirectory();
    final file = File('${output.path}/receipt_${order.orderNumber}.pdf');
    await file.writeAsBytes(await pdf.save());
    
    return file;
  }

  /// Share PDF via WhatsApp
  Future<void> _shareViaWhatsApp(File pdfFile) async {
    await Share.shareXFiles(
      [XFile(pdfFile.path)],
      text: 'Here is your receipt from Sentosa Cafe',
      subject: 'Receipt - Sentosa Cafe',
    );
  }

  /// Print receipt
  Future<void> _printReceipt(order_entity.Order order) async {
    CustomToast.show(
      context,
      message: 'Printing receipt...',
      backgroundColor: const Color(0xFF5E8C52),
      textColor: Colors.white,
      icon: Icons.check_circle_outline,
    );
    
    // Show a dialog indicating print was initiated
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF5E8C52).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.print_rounded,
                  color: Color(0xFF5E8C52),
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Printing Receipt',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Receipt is being sent to the printer',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5E8C52),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Select date range
  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            primaryColor: const Color(0xFF5E8C52),
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: const Color(0xFF5E8C52),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
      _filterOrders();
    }
  }

  // ==================== Helper Methods ====================

  /// Format price with thousands separator (Indonesian format)
  String _formatPrice(int price) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(price);
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  /// Format time for display
  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Format date and time for display
  String _formatDateTime(DateTime date) {
    return '${DateFormat('MMM dd, yyyy').format(date)} at ${_formatTime(date)}';
  }

  /// Get status color
  Color _getStatusColor(String status) {
    switch (status) {
      case 'paid':
        return const Color(0xFF5E8C52);
      case 'pending':
        return const Color(0xFFFFA726);
      case 'cancelled':
        return const Color(0xFFEF5350);
      case 'refunded':
        return const Color(0xFFAB47BC);
      default:
        return Colors.grey;
    }
  }

  /// Get status text
  String _getStatusText(String status) {
    switch (status) {
      case 'paid':
        return 'Paid';
      case 'pending':
        return 'Pending';
      case 'cancelled':
        return 'Cancelled';
      case 'refunded':
        return 'Refunded';
      default:
        return status;
    }
  }

  /// Get payment method icon
  IconData _getPaymentMethodIcon(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return Icons.money;
      case 'card':
        return Icons.credit_card;
      case 'transfer':
        return Icons.account_balance;
      case 'ewallet':
        return Icons.phone_android;
      default:
        return Icons.payment;
    }
  }

  /// Get payment method text
  String _getPaymentMethodText(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return 'Cash';
      case 'card':
        return 'Card';
      case 'transfer':
        return 'Transfer';
      case 'ewallet':
        return 'E-Wallet';
      default:
        return method;
    }
  }
}
