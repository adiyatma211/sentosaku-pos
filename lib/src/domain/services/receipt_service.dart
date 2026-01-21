import '../entities/order.dart';

abstract class ReceiptService {
  /// Generate a receipt for an order
  Future<String> generateReceipt({
    required Order order,
    Map<String, dynamic>? options,
  });
}