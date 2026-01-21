import '../entities/order.dart';

abstract class TransactionService {
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

  Future<void> refundTransaction({
    required int orderId,
    required String reason,
    double? refundAmount,
  });

  Future<void> voidTransaction({
    required int orderId,
    required String reason,
  });
}