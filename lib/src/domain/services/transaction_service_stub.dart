import 'package:dartz/dartz.dart';
import '../entities/failure.dart';
import '../entities/order.dart' as order_entity;

class TransactionServiceStub {
  Future<Either<Failure, order_entity.Order>> processTransaction({
    required int cartId,
    required String paymentMethod,
    required int paidAmount,
  }) async {
    print('DEBUG TRANSACTION STUB: processTransaction() START');
    print('DEBUG TRANSACTION STUB: cartId: $cartId, paymentMethod: $paymentMethod, paidAmount: $paidAmount');
    
    // Simulate processing time
    await Future.delayed(const Duration(seconds: 2));

    // Create a mock order
    final order = order_entity.Order(
      id: DateTime.now().millisecondsSinceEpoch,
      uuid: 'mock-uuid-${DateTime.now().millisecondsSinceEpoch}',
      orderNumber: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      customerName: null,
      customerPhone: null,
      customerEmail: null,
      customerAddress: null,
      subtotal: 100,
      taxAmount: 10,
      discountAmount: 0,
      totalAmount: 110,
      paidAmount: paidAmount,
      changeAmount: paidAmount - 110,
      status: 'paid',
      paymentStatus: 'paid',
      paymentMethod: paymentMethod,
      notes: null,
      orderDate: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isDeleted: false,
      syncStatus: 'synced',
      items: [], // This would be populated with actual cart items
      payments: null,
    );

    print('DEBUG TRANSACTION STUB: Mock order created - ID: ${order.id}, UUID: ${order.uuid}, Order Number: ${order.orderNumber}');
    print('DEBUG TRANSACTION STUB: WARNING - This is a STUB implementation. The order is NOT saved to the database!');
    print('DEBUG TRANSACTION STUB: processTransaction() END');
    return Right(order);
  }
}