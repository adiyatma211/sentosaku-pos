import '../entities/order.dart';

abstract class PaymentRepositoryInterface {
  // Payment CRUD operations
  Future<List<Payment>> getAllPayments();
  Future<List<Payment>> getPaymentsByOrder(int orderId);
  Future<List<Payment>> getPaymentsByStatus(String status);
  Future<List<Payment>> getPaymentsByMethod(String paymentMethod);
  Future<List<Payment>> getPaymentsByDateRange(DateTime startDate, DateTime endDate);
  Future<Payment?> getPaymentById(int id);
  Future<Payment?> getPaymentByUuid(String uuid);
  Future<Payment> createPayment(Payment payment);
  Future<Payment> updatePayment(Payment payment);
  Future<bool> deletePayment(int id);
  Future<bool> softDeletePayment(int id);
  
  // Payment processing operations
  Future<Payment> processPayment(PaymentRequest paymentRequest, int orderId);
  Future<bool> refundPayment(int paymentId, String reason);
  Future<bool> voidPayment(int paymentId, String reason);
  
  // Payment statistics
  Future<Map<String, dynamic>> getPaymentStatistics(DateTime startDate, DateTime endDate);
  Future<Map<String, dynamic>> getTodayPaymentStatistics();
  Future<Map<String, dynamic>> getPaymentMethodStatistics(DateTime startDate, DateTime endDate);
}