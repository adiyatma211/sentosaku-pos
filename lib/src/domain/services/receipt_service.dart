import '../entities/order.dart';
import '../entities/business_settings.dart';
import '../entities/printer_settings.dart';

abstract class ReceiptService {
  /// Generate a receipt for an order
  Future<String> generateReceipt({
    required Order order,
    Map<String, dynamic>? options,
    BusinessSettings? businessSettings,
    PrinterSettings? printerSettings,
  });
}