import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../datasources/local/app_database.dart';
import '../../domain/entities/order.dart' as entity;
import '../../domain/entities/product.dart' as product_entity;
import '../../domain/repositories/order_repository_interface.dart';

class OrderRepository implements OrderRepositoryInterface {
  final AppDatabase _database;
  
  OrderRepository(this._database);
  
  // Order CRUD operations
  @override
  Future<List<entity.Order>> getAllOrders() async {
    final orders = await (_database.select(_database.orders)
          ..where((tbl) => tbl.isDeleted.equals(false)))
        .get();
    
    return orders.map(_mapOrderToEntity).toList();
  }
  
  @override
  Future<List<entity.Order>> getOrdersByStatus(String status) async {
    final orders = await (_database.select(_database.orders)
          ..where((tbl) => tbl.isDeleted.equals(false) & tbl.status.equals(status)))
        .get();
    
    return orders.map(_mapOrderToEntity).toList();
  }
  
  @override
  Future<List<entity.Order>> getOrdersByDateRange(DateTime startDate, DateTime endDate) async {
    final orders = await (_database.select(_database.orders)
          ..where((tbl) => tbl.isDeleted.equals(false) & 
                           tbl.orderDate.isBetweenValues(startDate, endDate)))
        .get();
    
    return orders.map(_mapOrderToEntity).toList();
  }
  
  @override
  Future<List<entity.Order>> getTodayOrders() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));
    
    final orders = await (_database.select(_database.orders)
          ..where((tbl) => tbl.isDeleted.equals(false) & 
                           tbl.orderDate.isBetweenValues(startOfDay, endOfDay)))
        .get();
    
    return orders.map(_mapOrderToEntity).toList();
  }
  
  @override
  Future<entity.Order?> getOrderById(int id) async {
    final order = await (_database.select(_database.orders)
          ..where((tbl) => tbl.id.equals(id) & tbl.isDeleted.equals(false)))
        .getSingleOrNull();
    
    return order != null ? _mapOrderToEntity(order) : null;
  }
  
  @override
  Future<entity.Order?> getOrderByUuid(String uuid) async {
    final order = await (_database.select(_database.orders)
          ..where((tbl) => tbl.uuid.equals(uuid) & tbl.isDeleted.equals(false)))
        .getSingleOrNull();
    
    return order != null ? _mapOrderToEntity(order) : null;
  }
  
  @override
  Future<entity.Order?> getOrderByNumber(String orderNumber) async {
    final order = await (_database.select(_database.orders)
          ..where((tbl) => tbl.orderNumber.equals(orderNumber) & tbl.isDeleted.equals(false)))
        .getSingleOrNull();
    
    return order != null ? _mapOrderToEntity(order) : null;
  }
  
  @override
  Future<entity.Order> createOrder(entity.Order order) async {
    final orderCompanion = OrdersCompanion.insert(
      uuid: order.uuid,
      orderNumber: order.orderNumber,
      customerName: Value(order.customerName),
      customerPhone: Value(order.customerPhone),
      customerEmail: Value(order.customerEmail),
      customerAddress: Value(order.customerAddress),
      subtotal: order.subtotal,
      taxAmount: Value(order.taxAmount),
      discountAmount: Value(order.discountAmount),
      totalAmount: order.totalAmount,
      paidAmount: Value(order.paidAmount),
      changeAmount: Value(order.changeAmount),
      status: Value(order.status),
      paymentStatus: Value(order.paymentStatus),
      paymentMethod: Value(order.paymentMethod),
      notes: Value(order.notes),
      orderDate: Value(order.orderDate),
    );
    
    final id = await _database.into(_database.orders).insert(orderCompanion);
    final insertedOrder = await getOrderById(id);
    
    if (insertedOrder == null) {
      throw Exception('Failed to create order');
    }
    
    return insertedOrder;
  }
  
  @override
  Future<entity.Order> updateOrder(entity.Order order) async {
    print('DEBUG UPDATE ORDER: Starting updateOrder for UUID: ${order.uuid}');
    print('DEBUG UPDATE ORDER: Order ID: ${order.id}, Order Number: ${order.orderNumber}');
    print('DEBUG UPDATE ORDER: Paid Amount: ${order.paidAmount}, Change Amount: ${order.changeAmount}');
    print('DEBUG UPDATE ORDER: order.id is null: ${order.id == null}');
    
    final orderCompanion = OrdersCompanion(
      id: Value(order.id), // ADDING THE MISSING ID FIELD
      uuid: Value(order.uuid),
      orderNumber: Value(order.orderNumber),
      customerName: Value(order.customerName),
      customerPhone: Value(order.customerPhone),
      customerEmail: Value(order.customerEmail),
      customerAddress: Value(order.customerAddress),
      subtotal: Value(order.subtotal),
      taxAmount: Value(order.taxAmount),
      discountAmount: Value(order.discountAmount),
      totalAmount: Value(order.totalAmount),
      paidAmount: Value(order.paidAmount),
      changeAmount: Value(order.changeAmount),
      status: Value(order.status),
      paymentStatus: Value(order.paymentStatus),
      paymentMethod: Value(order.paymentMethod),
      notes: Value(order.notes),
      orderDate: Value(order.orderDate),
      updatedAt: Value(DateTime.now()),
    );
    
    print('DEBUG UPDATE ORDER: Created orderCompanion with id: ${orderCompanion.id.value}');
    print('DEBUG UPDATE ORDER: Updating database...');
    await _database.update(_database.orders).replace(orderCompanion);
    print('DEBUG UPDATE ORDER: Database update completed, retrieving updated order...');
    
    final updatedOrder = await getOrderByUuid(order.uuid);
    print('DEBUG UPDATE ORDER: Retrieved updated order: ${updatedOrder != null}');
    
    if (updatedOrder == null) {
      print('DEBUG UPDATE ORDER: ERROR - Failed to retrieve updated order');
      throw Exception('Failed to update order');
    }
    
    print('DEBUG UPDATE ORDER: Successfully updated order - ID: ${updatedOrder.id}, UUID: ${updatedOrder.uuid}');
    return updatedOrder;
  }
  
  @override
  Future<bool> deleteOrder(int id) async {
    await (_database.delete(_database.orders)
        ..where((tbl) => tbl.id.equals(id)))
        .go();
    
    return true;
  }
  
  @override
  Future<bool> softDeleteOrder(int id) async {
    await (_database.update(_database.orders)
        ..where((tbl) => tbl.id.equals(id)))
        .write(OrdersCompanion(
          isDeleted: const Value(true),
          updatedAt: Value(DateTime.now()),
        ));
    
    return true;
  }
  
  // Order item operations
  @override
  Future<List<entity.OrderItem>> getOrderItems(int orderId) async {
    final orderItems = await (_database.select(_database.orderItems)
          ..where((tbl) => tbl.orderId.equals(orderId) & tbl.isDeleted.equals(false)))
        .get();
    
    return orderItems.map(_mapOrderItemToEntity).toList();
  }
  
  @override
  Future<entity.OrderItem?> getOrderItemById(int id) async {
    final orderItem = await (_database.select(_database.orderItems)
          ..where((tbl) => tbl.id.equals(id) & tbl.isDeleted.equals(false)))
        .getSingleOrNull();
    
    return orderItem != null ? _mapOrderItemToEntity(orderItem) : null;
  }
  
  @override
  Future<entity.OrderItem?> getOrderItemByUuid(String uuid) async {
    final orderItem = await (_database.select(_database.orderItems)
          ..where((tbl) => tbl.uuid.equals(uuid) & tbl.isDeleted.equals(false)))
        .getSingleOrNull();
    
    return orderItem != null ? _mapOrderItemToEntity(orderItem) : null;
  }
  
  @override
  Future<entity.OrderItem> createOrderItem(entity.OrderItem orderItem) async {
    final orderItemCompanion = OrderItemsCompanion.insert(
      uuid: orderItem.uuid,
      orderId: orderItem.orderId,
      productId: orderItem.productId,
      variantId: Value(orderItem.variantId),
      productName: orderItem.productName,
      variantName: Value(orderItem.variantName),
      quantity: orderItem.quantity,
      unitPrice: orderItem.unitPrice,
      totalPrice: orderItem.totalPrice,
      discountAmount: Value(orderItem.discountAmount),
      notes: Value(orderItem.notes),
    );
    
    final id = await _database.into(_database.orderItems).insert(orderItemCompanion);
    final insertedOrderItem = await getOrderItemById(id);
    
    if (insertedOrderItem == null) {
      throw Exception('Failed to create order item');
    }
    
    return insertedOrderItem;
  }
  
  @override
  Future<entity.OrderItem> updateOrderItem(entity.OrderItem orderItem) async {
    final orderItemCompanion = OrderItemsCompanion(
      uuid: Value(orderItem.uuid),
      orderId: Value(orderItem.orderId),
      productId: Value(orderItem.productId),
      variantId: Value(orderItem.variantId),
      productName: Value(orderItem.productName),
      variantName: Value(orderItem.variantName),
      quantity: Value(orderItem.quantity),
      unitPrice: Value(orderItem.unitPrice),
      totalPrice: Value(orderItem.totalPrice),
      discountAmount: Value(orderItem.discountAmount),
      notes: Value(orderItem.notes),
      updatedAt: Value(DateTime.now()),
    );
    
    await _database.update(_database.orderItems).replace(orderItemCompanion);
    final updatedOrderItem = await getOrderItemByUuid(orderItem.uuid);
    
    if (updatedOrderItem == null) {
      throw Exception('Failed to update order item');
    }
    
    return updatedOrderItem;
  }
  
  @override
  Future<bool> deleteOrderItem(int id) async {
    await (_database.delete(_database.orderItems)
        ..where((tbl) => tbl.id.equals(id)))
        .go();
    
    return true;
  }
  
  @override
  Future<bool> softDeleteOrderItem(int id) async {
    await (_database.update(_database.orderItems)
        ..where((tbl) => tbl.id.equals(id)))
        .write(OrderItemsCompanion(
          isDeleted: const Value(true),
          updatedAt: Value(DateTime.now()),
        ));
    
    return true;
  }
  
  // Transaction operations
  @override
  Future<entity.TransactionResult> processTransaction(entity.TransactionRequest request) async {
    return _database.transaction(() async {
      try {
        // Generate order UUID and number
        final orderUuid = Uuid().v4();
        final orderNumber = _generateOrderNumber();
        
        // Create order
        final order = entity.Order(
          id: 0, // Will be set by database
          uuid: orderUuid,
          orderNumber: orderNumber,
          customerName: request.customerName,
          customerPhone: request.customerPhone,
          customerEmail: request.customerEmail,
          customerAddress: request.customerAddress,
          subtotal: request.subtotal,
          taxAmount: request.taxAmount,
          discountAmount: request.discountAmount,
          totalAmount: request.totalAmount,
          paidAmount: 0, // Will be updated after payments
          changeAmount: 0, // Will be calculated after payments
          status: 'pending',
          paymentStatus: 'unpaid',
          paymentMethod: null, // Will be set based on payments
          notes: request.notes,
          orderDate: DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isDeleted: false,
          syncStatus: 'pending',
        );
        
        final createdOrder = await createOrder(order);
        
        // Create order items
        final List<entity.OrderItem> createdOrderItems = [];
        for (final item in request.items) {
          final orderItem = entity.OrderItem(
            id: 0, // Will be set by database
            uuid: Uuid().v4(),
            orderId: createdOrder.id,
            productId: item.productId,
            variantId: item.variantId,
            productName: item.productName,
            variantName: item.variantName,
            quantity: item.quantity,
            unitPrice: item.unitPrice,
            totalPrice: item.totalPrice,
            discountAmount: item.discountAmount,
            notes: item.notes,
            customizations: item.customizations,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            isDeleted: false,
            syncStatus: 'pending',
          );
          
          final createdOrderItem = await createOrderItem(orderItem);
          createdOrderItems.add(createdOrderItem);
          
          // Update stock and create stock movements
          await _updateStockForOrderItem(createdOrderItem);
        }
        
        // Process payments
        int totalPaid = 0;
        final List<entity.Payment> createdPayments = [];
        
        for (final paymentRequest in request.payments) {
          final payment = entity.Payment(
            id: 0, // Will be set by database
            uuid: Uuid().v4(),
            orderId: createdOrder.id,
            paymentMethod: paymentRequest.paymentMethod,
            amount: paymentRequest.amount,
            reference: paymentRequest.reference,
            status: 'completed',
            gateway: null,
            gatewayTransactionId: null,
            paymentDate: DateTime.now(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            isDeleted: false,
            syncStatus: 'pending',
          );
          
          // Create payment through payment repository
          // This would be implemented when we create payment repository
          // For now, we'll create it directly
          final paymentCompanion = PaymentsCompanion.insert(
            uuid: payment.uuid,
            orderId: payment.orderId,
            paymentMethod: payment.paymentMethod,
            amount: payment.amount,
            reference: Value(payment.reference),
            status: const Value('completed'),
            gateway: Value(null),
            gatewayTransactionId: Value(null),
            paymentDate: Value(payment.paymentDate),
          );
          
          await _database.into(_database.payments).insert(paymentCompanion);
          createdPayments.add(payment);
          totalPaid += payment.amount;
        }
        
        // Calculate change
        final changeAmount = totalPaid - request.totalAmount;
        
        // Update order with payment information
        final updatedOrder = createdOrder.copyWith(
          paidAmount: totalPaid,
          changeAmount: changeAmount > 0 ? changeAmount : 0,
          status: totalPaid >= request.totalAmount ? 'paid' : 'partial',
          paymentStatus: totalPaid >= request.totalAmount ? 'paid' : 'partial',
          paymentMethod: request.payments.isNotEmpty ? request.payments.first.paymentMethod : null,
        );
        
        await updateOrder(updatedOrder);
        
        // Create audit log
        await _createAuditLog('create', 'order', orderUuid, null, {
          'orderNumber': orderNumber,
          'totalAmount': request.totalAmount,
          'paymentMethod': request.payments.isNotEmpty ? request.payments.first.paymentMethod : null,
        });
        
        return entity.TransactionResult(
          success: true,
          order: updatedOrder.copyWith(
            items: createdOrderItems,
            payments: createdPayments,
          ),
          error: null,
          errorCode: null,
        );
      } catch (e) {
        // Create error audit log
        await _createAuditLog('error', 'transaction', null, null, {
          'error': e.toString(),
        });
        
        return entity.TransactionResult(
          success: false,
          order: null,
          error: e.toString(),
          errorCode: 'TRANSACTION_FAILED',
        );
      }
    });
  }
  
  @override
  Future<bool> cancelOrder(int orderId, String reason) async {
    return _database.transaction(() async {
      final order = await getOrderById(orderId);
      if (order == null) {
        throw Exception('Order not found');
      }
      
      // Update order status
      final updatedOrder = order.copyWith(
        status: 'cancelled',
        notes: '${order.notes ?? ''}\n\nCancelled: $reason',
        updatedAt: DateTime.now(),
      );
      
      await updateOrder(updatedOrder);
      
      // Restore stock for cancelled order items
      final orderItems = await getOrderItems(orderId);
      for (final orderItem in orderItems) {
        await _restoreStockForOrderItem(orderItem);
      }
      
      // Create audit log
      await _createAuditLog('cancel', 'order', order.uuid, null, {
        'reason': reason,
      });
      
      return true;
    });
  }
  
  @override
  Future<bool> refundOrder(int orderId, String reason) async {
    return _database.transaction(() async {
      final order = await getOrderById(orderId);
      if (order == null) {
        throw Exception('Order not found');
      }
      
      // Update order status
      final updatedOrder = order.copyWith(
        status: 'refunded',
        notes: '${order.notes ?? ''}\n\nRefunded: $reason',
        updatedAt: DateTime.now(),
      );
      
      await updateOrder(updatedOrder);
      
      // Restore stock for refunded order items
      final orderItems = await getOrderItems(orderId);
      for (final orderItem in orderItems) {
        await _restoreStockForOrderItem(orderItem);
      }
      
      // Create audit log
      await _createAuditLog('refund', 'order', order.uuid, null, {
        'reason': reason,
      });
      
      return true;
    });
  }
  
  @override
  Future<bool> refundOrderItem(int orderItemId, String reason) async {
    return _database.transaction(() async {
      final orderItem = await getOrderItemById(orderItemId);
      if (orderItem == null) {
        throw Exception('Order item not found');
      }
      
      // Soft delete order item
      await softDeleteOrderItem(orderItemId);
      
      // Restore stock
      await _restoreStockForOrderItem(orderItem);
      
      // Recalculate order totals
      final order = await getOrderById(orderItem.orderId);
      if (order != null) {
        final remainingItems = await getOrderItems(orderItem.orderId);
        final newSubtotal = remainingItems.fold<int>(0, (sum, item) => sum + item.totalPrice);
        final newTotalAmount = newSubtotal + order.taxAmount - order.discountAmount;
        
        final updatedOrder = order.copyWith(
          subtotal: newSubtotal,
          totalAmount: newTotalAmount,
          notes: '${order.notes ?? ''}\n\nItem refunded: ${orderItem.productName} - $reason',
          updatedAt: DateTime.now(),
        );
        
        await updateOrder(updatedOrder);
      }
      
      // Create audit log
      await _createAuditLog('refund', 'order_item', orderItem.uuid, null, {
        'reason': reason,
      });
      
      return true;
    });
  }
  
  // Order statistics
  @override
  Future<Map<String, dynamic>> getOrderStatistics(DateTime startDate, DateTime endDate) async {
    final orders = await getOrdersByDateRange(startDate, endDate);
    
    final totalOrders = orders.length;
    final totalRevenue = orders.fold<int>(0, (sum, order) => sum + order.totalAmount);
    final paidOrders = orders.where((order) => order.status == 'paid').length;
    final pendingOrders = orders.where((order) => order.status == 'pending').length;
    final cancelledOrders = orders.where((order) => order.status == 'cancelled').length;
    final refundedOrders = orders.where((order) => order.status == 'refunded').length;
    
    return {
      'totalOrders': totalOrders,
      'totalRevenue': totalRevenue,
      'paidOrders': paidOrders,
      'pendingOrders': pendingOrders,
      'cancelledOrders': cancelledOrders,
      'refundedOrders': refundedOrders,
      'averageOrderValue': totalOrders > 0 ? totalRevenue / totalOrders : 0,
    };
  }
  
  @override
  Future<Map<String, dynamic>> getTodayOrderStatistics() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));
    
    return getOrderStatistics(startOfDay, endOfDay);
  }
  
  @override
  Future<List<entity.Order>> getTopSellingProducts(DateTime startDate, DateTime endDate, int limit) async {
    // This would require joining orders and order items and grouping by product
    // For now, we'll return empty list as this is a complex query
    // In a real implementation, this would be a custom SQL query
    return [];
  }
  
  // Search operations
  @override
  Future<List<entity.Order>> searchOrders(String query) async {
    final orders = await (_database.select(_database.orders)
          ..where((tbl) => tbl.isDeleted.equals(false) & 
                           (tbl.orderNumber.contains(query) | 
                             tbl.customerName.contains(query))))
        .get();
    
    return orders.map(_mapOrderToEntity).toList();
  }
  
  @override
  Future<List<entity.Order>> searchOrdersByCustomer(String customerName) async {
    final orders = await (_database.select(_database.orders)
          ..where((tbl) => tbl.isDeleted.equals(false) & 
                           tbl.customerName.contains(customerName)))
        .get();
    
    return orders.map(_mapOrderToEntity).toList();
  }
  
  // Helper methods
  String _generateOrderNumber() {
    final now = DateTime.now();
    final dateStr = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final random = DateTime.now().millisecondsSinceEpoch % 1000;
    return 'ORD$dateStr${random.toString().padLeft(3, '0')}';
  }
  
  Future<void> _updateStockForOrderItem(entity.OrderItem orderItem) async {
    // Get product information
    final product = await (_database.select(_database.products)
          ..where((tbl) => tbl.id.equals(orderItem.productId)))
        .getSingleOrNull();
    
    if (product == null) {
      throw Exception('Product not found');
    }
    
    // Update product stock if tracking is enabled
    if (product.isTrackStock) {
      final newStockQuantity = product.stockQuantity - orderItem.quantity;
      
      await (_database.update(_database.products)
          ..where((tbl) => tbl.id.equals(orderItem.productId)))
          .write(ProductsCompanion(
            stockQuantity: Value(newStockQuantity),
            updatedAt: Value(DateTime.now()),
          ));
      
      // Create stock movement
      await _database.into(_database.stockMovements).insert(
        StockMovementsCompanion.insert(
          uuid: Uuid().v4(),
          productId: orderItem.productId,
          movementType: 'sale',
          quantity: orderItem.quantity,
          previousQuantity: product.stockQuantity,
          newQuantity: newStockQuantity,
          referenceId: Value(orderItem.orderId.toString()),
          referenceType: const Value('order'),
        ),
      );
    }
    
    // Update variant stock if variant is specified
    if (orderItem.variantId != null) {
      final variant = await (_database.select(_database.variants)
            ..where((tbl) => tbl.id.equals(orderItem.variantId!)))
          .getSingleOrNull();
      
      if (variant != null) {
        final newVariantStockQuantity = variant.stockQuantity - orderItem.quantity;
        
        await (_database.update(_database.variants)
            ..where((tbl) => tbl.id.equals(orderItem.variantId!)))
            .write(VariantsCompanion(
              stockQuantity: Value(newVariantStockQuantity),
              updatedAt: Value(DateTime.now()),
            ));
        
        // Create stock movement for variant
        await _database.into(_database.stockMovements).insert(
          StockMovementsCompanion.insert(
            uuid: Uuid().v4(),
            productId: orderItem.productId,
            variantId: Value(orderItem.variantId),
            movementType: 'sale',
            quantity: orderItem.quantity,
            previousQuantity: variant.stockQuantity,
            newQuantity: newVariantStockQuantity,
            referenceId: Value(orderItem.orderId.toString()),
            referenceType: const Value('order'),
          ),
        );
      }
    }
    
    // Update ingredient stock based on recipes
    final recipes = await (_database.select(_database.recipes)
          ..where((tbl) => tbl.productId.equals(orderItem.productId)))
        .get();
    
    for (final recipe in recipes) {
      final ingredientUsage = recipe.quantity * orderItem.quantity;
      
      final ingredient = await (_database.select(_database.ingredients)
            ..where((tbl) => tbl.id.equals(recipe.ingredientId)))
          .getSingleOrNull();
      
      if (ingredient != null) {
        final newIngredientStockQuantity = ingredient.stockQuantity - ingredientUsage.toInt();
        
        await (_database.update(_database.ingredients)
            ..where((tbl) => tbl.id.equals(recipe.ingredientId)))
            .write(IngredientsCompanion(
              stockQuantity: Value(newIngredientStockQuantity),
              updatedAt: Value(DateTime.now()),
            ));
        
        // Create stock movement for ingredient
        await _database.into(_database.stockMovements).insert(
          StockMovementsCompanion.insert(
            uuid: Uuid().v4(),
            productId: orderItem.productId,
            ingredientId: Value(recipe.ingredientId),
            movementType: 'sale',
            quantity: ingredientUsage.toInt(),
            previousQuantity: ingredient.stockQuantity,
            newQuantity: newIngredientStockQuantity,
            referenceId: Value(orderItem.orderId.toString()),
            referenceType: const Value('order'),
          ),
        );
      }
    }
  }
  
  Future<void> _restoreStockForOrderItem(entity.OrderItem orderItem) async {
    // Get product information
    final product = await (_database.select(_database.products)
          ..where((tbl) => tbl.id.equals(orderItem.productId)))
        .getSingleOrNull();
    
    if (product == null) {
      throw Exception('Product not found');
    }
    
    // Update product stock if tracking is enabled
    if (product.isTrackStock) {
      final newStockQuantity = product.stockQuantity + orderItem.quantity;
      
      await (_database.update(_database.products)
          ..where((tbl) => tbl.id.equals(orderItem.productId)))
          .write(ProductsCompanion(
            stockQuantity: Value(newStockQuantity),
            updatedAt: Value(DateTime.now()),
          ));
      
      // Create stock movement
      await _database.into(_database.stockMovements).insert(
        StockMovementsCompanion.insert(
          uuid: Uuid().v4(),
          productId: orderItem.productId,
          movementType: 'return',
          quantity: orderItem.quantity,
          previousQuantity: product.stockQuantity,
          newQuantity: newStockQuantity,
          referenceId: Value(orderItem.orderId.toString()),
          referenceType: const Value('order'),
        ),
      );
    }
    
    // Update variant stock if variant is specified
    if (orderItem.variantId != null) {
      final variant = await (_database.select(_database.variants)
            ..where((tbl) => tbl.id.equals(orderItem.variantId!)))
          .getSingleOrNull();
      
      if (variant != null) {
        final newVariantStockQuantity = variant.stockQuantity + orderItem.quantity;
        
        await (_database.update(_database.variants)
            ..where((tbl) => tbl.id.equals(orderItem.variantId!)))
            .write(VariantsCompanion(
              stockQuantity: Value(newVariantStockQuantity),
              updatedAt: Value(DateTime.now()),
            ));
        
        // Create stock movement for variant
        await _database.into(_database.stockMovements).insert(
          StockMovementsCompanion.insert(
            uuid: Uuid().v4(),
            productId: orderItem.productId,
            variantId: Value(orderItem.variantId),
            movementType: 'return',
            quantity: orderItem.quantity,
            previousQuantity: variant.stockQuantity,
            newQuantity: newVariantStockQuantity,
            referenceId: Value(orderItem.orderId.toString()),
            referenceType: const Value('order'),
          ),
        );
      }
    }
    
    // Update ingredient stock based on recipes
    final recipes = await (_database.select(_database.recipes)
          ..where((tbl) => tbl.productId.equals(orderItem.productId)))
        .get();
    
    for (final recipe in recipes) {
      final ingredientUsage = recipe.quantity * orderItem.quantity;
      
      final ingredient = await (_database.select(_database.ingredients)
            ..where((tbl) => tbl.id.equals(recipe.ingredientId)))
          .getSingleOrNull();
      
      if (ingredient != null) {
        final newIngredientStockQuantity = ingredient.stockQuantity + ingredientUsage.toInt();
        
        await (_database.update(_database.ingredients)
            ..where((tbl) => tbl.id.equals(recipe.ingredientId)))
            .write(IngredientsCompanion(
              stockQuantity: Value(newIngredientStockQuantity),
              updatedAt: Value(DateTime.now()),
            ));
        
        // Create stock movement for ingredient
        await _database.into(_database.stockMovements).insert(
          StockMovementsCompanion.insert(
            uuid: Uuid().v4(),
            productId: orderItem.productId,
            ingredientId: Value(recipe.ingredientId),
            movementType: 'return',
            quantity: ingredientUsage.toInt(),
            previousQuantity: ingredient.stockQuantity,
            newQuantity: newIngredientStockQuantity,
            referenceId: Value(orderItem.orderId.toString()),
            referenceType: const Value('order'),
          ),
        );
      }
    }
  }
  
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
  entity.Order _mapOrderToEntity(Order data) {
    return entity.Order(
      id: data.id,
      uuid: data.uuid,
      orderNumber: data.orderNumber,
      customerName: data.customerName,
      customerPhone: data.customerPhone,
      customerEmail: data.customerEmail,
      customerAddress: data.customerAddress,
      subtotal: data.subtotal,
      taxAmount: data.taxAmount,
      discountAmount: data.discountAmount,
      totalAmount: data.totalAmount,
      paidAmount: data.paidAmount,
      changeAmount: data.changeAmount,
      status: data.status,
      paymentStatus: data.paymentStatus,
      paymentMethod: data.paymentMethod,
      notes: data.notes,
      orderDate: data.orderDate,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      isDeleted: data.isDeleted,
      syncStatus: data.syncStatus,
    );
  }
  
  entity.OrderItem _mapOrderItemToEntity(OrderItem data) {
    return entity.OrderItem(
      id: data.id,
      uuid: data.uuid,
      orderId: data.orderId,
      productId: data.productId,
      variantId: data.variantId,
      productName: data.productName,
      variantName: data.variantName,
      quantity: data.quantity,
      unitPrice: data.unitPrice,
      totalPrice: data.totalPrice,
      discountAmount: data.discountAmount,
      notes: data.notes,
      customizations: const {}, // Database doesn't store customizations, so we'll use empty map
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      isDeleted: data.isDeleted,
      syncStatus: data.syncStatus,
    );
  }
}