import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../datasources/local/app_database.dart';
import '../../domain/entities/order.dart' as entity;
import '../../domain/repositories/payment_repository_interface.dart';

class PaymentRepository implements PaymentRepositoryInterface {
  final AppDatabase _database;
  
  PaymentRepository(this._database);
  
  // Payment CRUD operations
  @override
  Future<List<entity.Payment>> getAllPayments() async {
    final payments = await (_database.select(_database.payments)
          ..where((tbl) => tbl.isDeleted.equals(false)))
        .get();
    
    return payments.map(_mapPaymentToEntity).toList();
  }
  
  @override
  Future<List<entity.Payment>> getPaymentsByOrder(int orderId) async {
    final payments = await (_database.select(_database.payments)
          ..where((tbl) => tbl.isDeleted.equals(false) & tbl.orderId.equals(orderId)))
        .get();
    
    return payments.map(_mapPaymentToEntity).toList();
  }
  
  @override
  Future<List<entity.Payment>> getPaymentsByStatus(String status) async {
    final payments = await (_database.select(_database.payments)
          ..where((tbl) => tbl.isDeleted.equals(false) & tbl.status.equals(status)))
        .get();
    
    return payments.map(_mapPaymentToEntity).toList();
  }
  
  @override
  Future<List<entity.Payment>> getPaymentsByMethod(String paymentMethod) async {
    final payments = await (_database.select(_database.payments)
          ..where((tbl) => tbl.isDeleted.equals(false) & tbl.paymentMethod.equals(paymentMethod)))
        .get();
    
    return payments.map(_mapPaymentToEntity).toList();
  }
  
  @override
  Future<List<entity.Payment>> getPaymentsByDateRange(DateTime startDate, DateTime endDate) async {
    final payments = await (_database.select(_database.payments)
          ..where((tbl) => tbl.isDeleted.equals(false) & 
                           tbl.paymentDate.isBetweenValues(startDate, endDate)))
        .get();
    
    return payments.map(_mapPaymentToEntity).toList();
  }
  
  @override
  Future<entity.Payment?> getPaymentById(int id) async {
    final payment = await (_database.select(_database.payments)
          ..where((tbl) => tbl.id.equals(id) & tbl.isDeleted.equals(false)))
        .getSingleOrNull();
    
    return payment != null ? _mapPaymentToEntity(payment) : null;
  }
  
  @override
  Future<entity.Payment?> getPaymentByUuid(String uuid) async {
    final payment = await (_database.select(_database.payments)
          ..where((tbl) => tbl.uuid.equals(uuid) & tbl.isDeleted.equals(false)))
        .getSingleOrNull();
    
    return payment != null ? _mapPaymentToEntity(payment) : null;
  }
  
  @override
  Future<entity.Payment> createPayment(entity.Payment payment) async {
    final paymentCompanion = PaymentsCompanion.insert(
      uuid: payment.uuid,
      orderId: payment.orderId,
      paymentMethod: payment.paymentMethod,
      amount: payment.amount,
      reference: Value(payment.reference),
      status: Value(payment.status),
      gateway: Value(payment.gateway),
      gatewayTransactionId: Value(payment.gatewayTransactionId),
      paymentDate: Value(payment.paymentDate),
    );
    
    final id = await _database.into(_database.payments).insert(paymentCompanion);
    final insertedPayment = await getPaymentById(id);
    
    if (insertedPayment == null) {
      throw Exception('Failed to create payment');
    }
    
    return insertedPayment;
  }
  
  @override
  Future<entity.Payment> updatePayment(entity.Payment payment) async {
    final paymentCompanion = PaymentsCompanion(
      uuid: Value(payment.uuid),
      orderId: Value(payment.orderId),
      paymentMethod: Value(payment.paymentMethod),
      amount: Value(payment.amount),
      reference: Value(payment.reference),
      status: Value(payment.status),
      gateway: Value(payment.gateway),
      gatewayTransactionId: Value(payment.gatewayTransactionId),
      paymentDate: Value(payment.paymentDate),
      updatedAt: Value(DateTime.now()),
    );
    
    await _database.update(_database.payments).replace(paymentCompanion);
    final updatedPayment = await getPaymentByUuid(payment.uuid);
    
    if (updatedPayment == null) {
      throw Exception('Failed to update payment');
    }
    
    return updatedPayment;
  }
  
  @override
  Future<bool> deletePayment(int id) async {
    await (_database.delete(_database.payments)
        ..where((tbl) => tbl.id.equals(id)))
        .go();
    
    return true;
  }
  
  @override
  Future<bool> softDeletePayment(int id) async {
    await (_database.update(_database.payments)
        ..where((tbl) => tbl.id.equals(id)))
        .write(PaymentsCompanion(
          isDeleted: const Value(true),
          updatedAt: Value(DateTime.now()),
        ));
    
    return true;
  }
  
  // Payment processing operations
  @override
  Future<entity.Payment> processPayment(entity.PaymentRequest paymentRequest, int orderId) async {
    final payment = entity.Payment(
      id: 0, // Will be set by database
      uuid: Uuid().v4(),
      orderId: orderId,
      paymentMethod: paymentRequest.paymentMethod,
      amount: paymentRequest.amount,
      reference: paymentRequest.reference,
      status: 'completed',
      paymentDate: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isDeleted: false,
      syncStatus: 'pending',
    );
    
    return createPayment(payment);
  }
  
  @override
  Future<bool> refundPayment(int paymentId, String reason) async {
    return _database.transaction(() async {
      final payment = await getPaymentById(paymentId);
      if (payment == null) {
        throw Exception('Payment not found');
      }
      
      // Update payment status
      final updatedPayment = payment.copyWith(
        status: 'refunded',
        updatedAt: DateTime.now(),
      );
      
      await updatePayment(updatedPayment);
      
      // Create audit log
      await _createAuditLog('refund', 'payment', payment.uuid, null, {
        'reason': reason,
      });
      
      return true;
    });
  }
  
  @override
  Future<bool> voidPayment(int paymentId, String reason) async {
    return _database.transaction(() async {
      final payment = await getPaymentById(paymentId);
      if (payment == null) {
        throw Exception('Payment not found');
      }
      
      // Update payment status
      final updatedPayment = payment.copyWith(
        status: 'voided',
        updatedAt: DateTime.now(),
      );
      
      await updatePayment(updatedPayment);
      
      // Create audit log
      await _createAuditLog('void', 'payment', payment.uuid, null, {
        'reason': reason,
      });
      
      return true;
    });
  }
  
  // Payment statistics
  @override
  Future<Map<String, dynamic>> getPaymentStatistics(DateTime startDate, DateTime endDate) async {
    final payments = await getPaymentsByDateRange(startDate, endDate);
    
    final totalPayments = payments.length;
    final totalAmount = payments.fold<int>(0, (sum, payment) => sum + payment.amount);
    final completedPayments = payments.where((payment) => payment.status == 'completed').length;
    final refundedPayments = payments.where((payment) => payment.status == 'refunded').length;
    final voidedPayments = payments.where((payment) => payment.status == 'voided').length;
    
    // Group by payment method
    final Map<String, int> paymentMethodCounts = {};
    final Map<String, int> paymentMethodTotals = {};
    
    for (final payment in payments) {
      final method = payment.paymentMethod;
      paymentMethodCounts[method] = (paymentMethodCounts[method] ?? 0) + 1;
      paymentMethodTotals[method] = (paymentMethodTotals[method] ?? 0) + payment.amount;
    }
    
    return {
      'totalPayments': totalPayments,
      'totalAmount': totalAmount,
      'completedPayments': completedPayments,
      'refundedPayments': refundedPayments,
      'voidedPayments': voidedPayments,
      'averagePaymentAmount': totalPayments > 0 ? totalAmount / totalPayments : 0,
      'paymentMethodCounts': paymentMethodCounts,
      'paymentMethodTotals': paymentMethodTotals,
    };
  }
  
  @override
  Future<Map<String, dynamic>> getTodayPaymentStatistics() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));
    
    return getPaymentStatistics(startOfDay, endOfDay);
  }
  
  @override
  Future<Map<String, dynamic>> getPaymentMethodStatistics(DateTime startDate, DateTime endDate) async {
    final payments = await getPaymentsByDateRange(startDate, endDate);
    
    // Group by payment method
    final Map<String, int> paymentMethodCounts = {};
    final Map<String, int> paymentMethodTotals = {};
    
    for (final payment in payments) {
      final method = payment.paymentMethod;
      paymentMethodCounts[method] = (paymentMethodCounts[method] ?? 0) + 1;
      paymentMethodTotals[method] = (paymentMethodTotals[method] ?? 0) + payment.amount;
    }
    
    return {
      'paymentMethodCounts': paymentMethodCounts,
      'paymentMethodTotals': paymentMethodTotals,
    };
  }
  
  // Helper methods
  Future<void> _createAuditLog(String action, String entityType, String? entityId, String? oldValues, Map<String, dynamic>? newValues) async {
    await _database.into(_database.auditLogs).insert(
      AuditLogsCompanion.insert(
        uuid: Uuid().v4(),
        action: action,
        entityType: entityType,
        entityId: Value(entityId),
        oldValues: Value(oldValues),
        newValues: Value(newValues?.toString()),
      ),
    );
  }
  
  // Mapping methods
  entity.Payment _mapPaymentToEntity(Payment data) {
    return entity.Payment(
      id: data.id,
      uuid: data.uuid,
      orderId: data.orderId,
      paymentMethod: data.paymentMethod,
      amount: data.amount,
      reference: data.reference,
      status: data.status,
      gateway: data.gateway,
      gatewayTransactionId: data.gatewayTransactionId,
      paymentDate: data.paymentDate,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      isDeleted: data.isDeleted,
      syncStatus: data.syncStatus,
    );
  }
}