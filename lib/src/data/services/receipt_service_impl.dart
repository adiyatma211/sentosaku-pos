import 'package:injectable/injectable.dart';

import '../../domain/services/receipt_service.dart';
import '../../domain/entities/order.dart' as order_entity;

@LazySingleton(as: ReceiptService)
class ReceiptServiceImpl implements ReceiptService {
  @override
  Future<String> generateReceipt({
    required order_entity.Order order,
    Map<String, dynamic>? options,
  }) async {
    // Generate receipt content
    final receiptContent = _buildReceiptContent(order, options);
    
    return receiptContent;
  }

  String _buildReceiptContent(order_entity.Order order, Map<String, dynamic>? options) {
    final buffer = StringBuffer();
    
    // Header
    buffer.writeln('================================');
    buffer.writeln('           SENTOSA POS');
    buffer.writeln('================================');
    buffer.writeln('');
    
    // Business info
    buffer.writeln('Business: Sentosa Cafe');
    buffer.writeln('Address: 123 Main Street, Jakarta');
    buffer.writeln('Phone: +62 812 3456');
    buffer.writeln('');
    
    // Order info
    buffer.writeln('ORDER #: ${order.orderNumber}');
    buffer.writeln('Date: ${_formatDate(order.orderDate)}');
    buffer.writeln('Time: ${_formatTime(order.orderDate)}');
    buffer.writeln('');
    
    // Customer info
    if (order.customerName != null) {
      buffer.writeln('Customer: ${order.customerName}');
    } else {
      buffer.writeln('Customer: Guest');
    }
    
    if (order.customerPhone != null) {
      buffer.writeln('Phone: ${order.customerPhone}');
    }
    
    if (order.customerEmail != null) {
      buffer.writeln('Email: ${order.customerEmail}');
    }
    
    if (order.customerAddress != null) {
      buffer.writeln('Address: ${order.customerAddress}');
    }
    
    buffer.writeln('');
    
    // Items
    buffer.writeln('--------------------------------');
    buffer.writeln('Items:');
    
    if (order.items != null) {
      for (final item in order.items!) {
        buffer.writeln('  ${item.quantity}x ${item.productName}');
        
        if (item.variantName != null) {
          buffer.writeln('    Variant: ${item.variantName}');
        }
        
        buffer.writeln('    Price: \$${item.unitPrice.toStringAsFixed(2)}');
        buffer.writeln('    Total: \$${item.totalPrice.toStringAsFixed(2)}');
        
        if (item.notes != null && item.notes!.isNotEmpty) {
          buffer.writeln('    Notes: ${item.notes}');
        }
        
        buffer.writeln('');
      }
    }
    
    buffer.writeln('--------------------------------');
    
    // Totals
    buffer.writeln('--------------------------------');
    buffer.writeln('Subtotal: \$${order.subtotal.toStringAsFixed(2)}');
    buffer.writeln('Tax (10%): \$${order.taxAmount.toStringAsFixed(2)}');
    buffer.writeln('Discount: \$${order.discountAmount.toStringAsFixed(2)}');
    buffer.writeln('');
    
    // Payment info
    buffer.writeln('--------------------------------');
    buffer.writeln('Payment Method: ${order.paymentMethod}');
    buffer.writeln('Paid: \$${order.paidAmount.toStringAsFixed(2)}');
    buffer.writeln('Change: \$${(order.paidAmount - order.totalAmount).toStringAsFixed(2)}');
    buffer.writeln('');
    
    // Footer
    buffer.writeln('================================');
    buffer.writeln('Thank you for your purchase!');
    buffer.writeln('Please come again soon.');
    buffer.writeln('');
    
    return buffer.toString();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    final second = date.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }
}