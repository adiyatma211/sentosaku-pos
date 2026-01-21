import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionHistoryScreen extends ConsumerStatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  ConsumerState<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends ConsumerState<TransactionHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
            },
            tooltip: 'Filter',
          ),
        ],
      ),
      body: Column(
        children: [
          // Date range selector
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _selectDateRange(context);
                    },
                    child: const Text('Select Date Range'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _showExportOptions(context);
                    },
                    child: const Text('Export'),
                  ),
                ),
              ],
            ),
          ),
          // Transaction summary
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem('Total Transactions', '24', context),
                _buildSummaryItem('Total Revenue', 'Rp 1,200,000', context),
                _buildSummaryItem('Avg. Transaction', 'Rp 50,000', context),
              ],
            ),
          ),
          // Transaction list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 24, // Sample count
              itemBuilder: (context, index) {
                return _buildTransactionItem(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          _showTransactionDetails(context, index);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order #${1000 + index}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Rp ${(45000 + (index * 1000)).toString()}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Today, ${10 + index % 8}:${30 + (index % 6) * 10} AM',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    index % 3 == 0 ? 'Guest' : 'Customer ${index % 5}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getStatusColor(index % 4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusText(index % 4),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(int statusIndex) {
    switch (statusIndex) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(int statusIndex) {
    switch (statusIndex) {
      case 0:
        return 'Completed';
      case 1:
        return 'Paid';
      case 2:
        return 'Refunded';
      default:
        return 'Void';
    }
  }

  void _showTransactionDetails(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order #${1000 + index} Details'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date: Today, ${10 + index % 8}:${30 + (index % 6) * 10} AM'),
              Text('Customer: ${index % 3 == 0 ? 'Guest' : 'Customer ${index % 5}'}'),
              const SizedBox(height: 16),
              const Text(
                'Items:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // Sample items
              for (int i = 0; i < 3; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${i + 1}x Product ${i + 1}'),
                      Text('Rp ${(15000 + i * 5000).toString()}'),
                    ],
                  ),
                ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Rp ${(45000 + (index * 1000)).toString()}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Payment Method:'),
                  Text(index % 2 == 0 ? 'Cash' : 'E-Wallet'),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _printReceipt(context, index);
            },
            child: const Text('Print Receipt'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Transactions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Status:'),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: true,
                  onSelected: (selected) {},
                ),
                FilterChip(
                  label: const Text('Completed'),
                  selected: false,
                  onSelected: (selected) {},
                ),
                FilterChip(
                  label: const Text('Refunded'),
                  selected: false,
                  onSelected: (selected) {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Payment Method:'),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: true,
                  onSelected: (selected) {},
                ),
                FilterChip(
                  label: const Text('Cash'),
                  selected: false,
                  onSelected: (selected) {},
                ),
                FilterChip(
                  label: const Text('E-Wallet'),
                  selected: false,
                  onSelected: (selected) {},
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Apply filters
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _selectDateRange(BuildContext context) {
    showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            primaryColor: Theme.of(context).primaryColor,
          ),
          child: child!,
        );
      },
    );
  }

  void _showExportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.picture_as_pdf),
            title: const Text('Export as PDF'),
            onTap: () {
              Navigator.of(context).pop();
              // Export as PDF
            },
          ),
          ListTile(
            leading: const Icon(Icons.table_chart),
            title: const Text('Export as Excel'),
            onTap: () {
              Navigator.of(context).pop();
              // Export as Excel
            },
          ),
          ListTile(
            leading: const Icon(Icons.print),
            title: const Text('Print Report'),
            onTap: () {
              Navigator.of(context).pop();
              // Print report
            },
          ),
        ],
      ),
    );
  }

  void _printReceipt(BuildContext context, int index) {
    // Print receipt logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Printing receipt...'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}