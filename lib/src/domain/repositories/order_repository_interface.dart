import '../entities/order.dart';

abstract class OrderRepositoryInterface {
  // Order CRUD operations
  Future<List<Order>> getAllOrders();
  Future<List<Order>> getOrdersByStatus(String status);
  Future<List<Order>> getOrdersByDateRange(DateTime startDate, DateTime endDate);
  Future<List<Order>> getTodayOrders();
  Future<Order?> getOrderById(int id);
  Future<Order?> getOrderByUuid(String uuid);
  Future<Order?> getOrderByNumber(String orderNumber);
  Future<Order> createOrder(Order order);
  Future<Order> updateOrder(Order order);
  Future<bool> deleteOrder(int id);
  Future<bool> softDeleteOrder(int id);
  
  // Order item operations
  Future<List<OrderItem>> getOrderItems(int orderId);
  Future<OrderItem?> getOrderItemById(int id);
  Future<OrderItem?> getOrderItemByUuid(String uuid);
  Future<OrderItem> createOrderItem(OrderItem orderItem);
  Future<OrderItem> updateOrderItem(OrderItem orderItem);
  Future<bool> deleteOrderItem(int id);
  Future<bool> softDeleteOrderItem(int id);
  
  // Transaction operations
  Future<TransactionResult> processTransaction(TransactionRequest request);
  Future<bool> cancelOrder(int orderId, String reason);
  Future<bool> refundOrder(int orderId, String reason);
  Future<bool> refundOrderItem(int orderItemId, String reason);
  
  // Order statistics
  Future<Map<String, dynamic>> getOrderStatistics(DateTime startDate, DateTime endDate);
  Future<Map<String, dynamic>> getTodayOrderStatistics();
  Future<List<Order>> getTopSellingProducts(DateTime startDate, DateTime endDate, int limit);
  
  // Search operations
  Future<List<Order>> searchOrders(String query);
  Future<List<Order>> searchOrdersByCustomer(String customerName);
}