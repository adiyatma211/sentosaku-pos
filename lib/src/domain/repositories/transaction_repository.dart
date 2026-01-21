import '../entities/order.dart';

abstract class TransactionRepository {
  /// Process a transaction with the given cart and payment details
  Future<Order> processTransaction({
    required int cartId,
    required String paymentMethod,
    required double paidAmount,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    String? customerAddress,
    String? notes,
  });

  /// Refund a transaction
  Future<void> refundTransaction({
    required int orderId,
    required String reason,
    double? refundAmount,
  });

  /// Void a transaction
  Future<void> voidTransaction({
    required int orderId,
    required String reason,
  });
}